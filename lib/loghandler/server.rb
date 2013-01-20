class Loghandler::Server < EM::Connection

  include MongoMapper

  MongoMapper.connection = Mongo::Connection.new()
  MongoMapper.database = "loghandler"

  def receive_data(data)
    data=JSON.parse(data)
    data = Hash[data.map{|(k,v)| [k.to_sym,v]}]
    data[:content].strip!
    puts "server recoit #{data} -- #{data.length} bytes"
    
    Loghandler::LogDetail.create!(data);
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
