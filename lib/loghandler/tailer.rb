class Loghandler::Tailer < EventMachine::FileTail
  def initialize(options,connection)
    @options = options
    @connection = connection
    super(options[:file])
  end

  def receive_data(data)
    @connection.report_data self,data
  end

end
