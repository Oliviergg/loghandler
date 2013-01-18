class Loghandler::Client < EM::Connection
  def self.run(options)
    EM.run do
      Signal.trap("INT") do
        EM.stop
      end
      connection = EventMachine.connect options[:url], options[:port], Loghandler::Client
      Loghandler::Tailer.new(options[:file],connection)
    end
  end
end
