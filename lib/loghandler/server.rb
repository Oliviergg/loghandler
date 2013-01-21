class Loghandler::Server < EM::Connection

  include MongoMapper

  MongoMapper.connection = Mongo::Connection.new()
  MongoMapper.database = "loghandler"

  def receive_data(rawdata)
    rawdata.each_line do |data|
      data=JSON.parse(data)
      data = Hash[data.map{|(k,v)| [k.to_sym,v]}]
      data[:content].strip!
      Loghandler::LogDetail.create!(data);
    end
    rescue => e
      puts "Error #{e} while trying to treat #{rawdata}"  
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
