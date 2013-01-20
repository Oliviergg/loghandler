class Loghandler::Tailer < EventMachine::FileTail
  def initialize(options,channel)
    @options = options
    @channel = channel
    super(options[:file])
  end

  def receive_data(data)
    @channel.push data
  end

end
