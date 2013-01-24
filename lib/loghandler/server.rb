require 'csv'
class Loghandler::Server < EM::Connection
  
  include MongoMapper

  MongoMapper.connection = Mongo::Connection.new()
  MongoMapper.database = "loghandler"

  def post_init
    @rules=Loghandler::Rules.constants.select {|c| Class === Loghandler::Rules.const_get(c)}
    @rules.delete(:AbstractRule)
    @tmp_line = []
  end

  def detect_matching_rules(log_detail)
    matching_rules = []

    @rules.each do |rule_name|
      rule_class = Loghandler::Rules.const_get(rule_name)
      rule = rule_class.new(log_detail)
      matching_rules << rule if rule.match?
    end

    return matching_rules
  end

  def apply_rules(log_detail)
    detect_matching_rules(log_detail).each do |rule|
      rule.apply!
      # puts "logging: #{rule.log}" if !rule.loggable?
      @@ws_channel.push(rule.log) if rule.loggable?
    end
    
  end
  
  def receive_data(rawdata)
    rawdata.each_line do |data|
      if (!@tmp_line.empty?)
        data = [@tmp_line,data].join
      end
      begin
        # TODO : Risk of infinite loop + Memory Leak. Find a better test than an Error on parsing.
        # => What's happen if one json is invalid ? At this time, the process can't detect anything
        data=JSON.parse(data)
      rescue => e
        # ligne incomplete
        @tmp_line << data
        next
      end
      @tmp_line = []
      data = Hash[data.map{|(k,v)| [k.to_sym,v]}]
      data[:content].strip!
      apply_rules(data)
    end
  end

  def self.run(options)
    EM.run do
      @@ws_channel = EventMachine::Channel.new

      Signal.trap("INT") do
        EM.stop
      end
      EventMachine.start_server options[:url], options[:port], Loghandler::Server 
      
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
          @@ws_channel.subscribe do |msg|
            ws.send msg
          end
          # ws.onopen {
          #   puts "WebSocket connection open"
          # }
          # ws.onclose { puts "Connection closed" }
          # ws.onmessage { |msg|
          #   puts "Recieved message: #{msg}"
          #   ws.send "Pong: #{msg}"
          # }
      end
      
   end # EM
  end

end
