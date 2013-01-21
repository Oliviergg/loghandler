class Loghandler::Server < EM::Connection

  include MongoMapper

  MongoMapper.connection = Mongo::Connection.new()
  MongoMapper.database = "loghandler"

  def post_init
    @rules=Loghandler::Rules.constants.select {|c| Class === Loghandler::Rules.const_get(c)}
    @rules.delete(:AbstractRule)
  end

  def apply_rule(log_detail)
    @rules.each do |rule_name|
      rule = Loghandler::Rules.const_get(rule_name)
      inst = rule.new(log_detail)
      return inst.convert if inst.match?
      return log_detail
    end
  end
  
  def receive_data(rawdata)
    rawdata.each_line do |data|
      data=JSON.parse(data)
      data = Hash[data.map{|(k,v)| [k.to_sym,v]}]
      data[:content].strip!
      
      data =  apply_rule(data)
      if data[:converted]
        puts data
      end
    end
    # rescue => e
    #   puts "Error #{e} while trying to treat #{rawdata}"  
  end

  def self.run(options)
    EM.run do
      Signal.trap("INT") do
        EM.stop
      end
      EventMachine.start_server(options[:url], options[:port], Loghandler::Server)
      
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
          ws.onopen {
            puts "WebSocket connection open"
      
            # publish message to the client
            ws.send "Hello Client"
          }
      
          ws.onclose { puts "Connection closed" }
          ws.onmessage { |msg|
            puts "Recieved message: #{msg}"
            ws.send "Pong: #{msg}"
          }
      end
      
     end
  end

end
