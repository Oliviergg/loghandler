class Loghandler::Server < EM::Connection
  def receive_data(data)
    data.strip!
    EM.stop if data=="quit"
    puts "server recoit #{data} -- #{data.length} bytes"
  end

  def self.run(options)
    EM.run do
      Signal.trap("INT") do
        EM.stop
      end
      EventMachine.start_server(options[:url], options[:port], Loghandler::Server)
     end
  end

end
