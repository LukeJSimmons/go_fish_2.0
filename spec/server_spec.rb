require 'server'

class MockFishSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

describe Server do
  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it 'has clients' do
    expect(@server).to respond_to :clients
  end

  it 'has a port_number' do
    expect(@server).to respond_to :port_number
  end

  describe '#accept_new_client' do
    let(:client1) { MockFishSocketClient.new(@server.port_number) }

    before do
      @clients.push(client1)
    end
    
    it 'sends a welcome message to client' do
      @server.accept_new_client('Player 1')
      expect(client1.capture_output).to match(/welcome/i)
    end
  end
end