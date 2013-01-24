class Loghandler::Tailer < EventMachine::FileTail
  def initialize(options,channel)
    @options = options
    @channel = channel
    super(options[:file])
  end

  def receive_data(data)
    data.each_line do |line|
      line.split("\n").each do |sline|
        @channel.push sline
      end
    end
  end

end
