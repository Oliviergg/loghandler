class Loghandler::Tailer < EventMachine::FileTail
  def initialize(file,connection)
    super(file)
    @connection = connection
  end

  def receive_data(data)
    puts "client (#{@path}) #{data}"
    @connection.send_data data
  end

end
