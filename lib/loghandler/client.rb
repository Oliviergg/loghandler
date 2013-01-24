require 'SecureRandom'
class Loghandler::Client < EM::Connection
  def initialize(args)
    super
    @options = args
    @reconnect_try = 0
  end
  
  def hostname
    Socket.gethostname
  end

  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
  
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
    ensure
      Socket.do_not_reverse_lookup = orig
  end

  def connection_completed
    @reconnect_try = 0
  end
  
  def unbind
    @reconnect_try+=1
    raise "Connection Lost - Max Try Reconnect #{@options[:max_reconnect]}" if @reconnect_try > @options[:max_reconnect]
    EM.add_timer(1) do reconnect  @options[:url], @options[:port] end
  end
  
  def self.run(options)
    EM.run do
      # EM.error_handler{ |e|
      #   puts "Error raised during event loop: #{e.message} "
      # }
      Signal.trap("INT") { EM.stop }
      options.merge!({max_reconnect:10})
      options.merge!({uid:SecureRandom.hex(10)}) if options[:uid].nil?
      channel = EventMachine::Channel.new
      
      client = EventMachine.connect options[:url], options[:port], Loghandler::Client, options
      # TODO : move into Loghandler::Client
      channel.subscribe do |data|
          to_send={content:data,logged_at:Time.now}.merge(options)
          client.send_data "#{to_send.to_json}\n"
      end
      Loghandler::Tailer.new(options,channel)
    end
  end
end
