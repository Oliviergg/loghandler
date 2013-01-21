class Loghandler::Client < EM::Connection
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
  
  def self.run(options)
    EM.run do
      Signal.trap("INT") do
        EM.stop
      end
      @@options = options
      channel = EventMachine::Channel.new
      client = EventMachine.connect options[:url], options[:port], Loghandler::Client
      channel.subscribe do |data|
          to_send={content:data,logged_at:Time.now}.merge(@@options)
          client.send_data "#{to_send.to_json}\n"
      end
      Loghandler::Tailer.new(options,channel)
    end
  end
end
