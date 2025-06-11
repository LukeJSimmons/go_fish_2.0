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

  it 'has rooms' do
    expect(@server).to respond_to :rooms
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

    it 'adds client to clients array' do
      expect {
        @server.accept_new_client('Player 1')
      }.to change(@server.clients, :count).by 1
    end
  end

  describe '#create_room_if_possible' do
    context 'when there is only one player' do
      let(:client1) { MockFishSocketClient.new(@server.port_number) }

      before do
        @clients.push(client1)
        @server.accept_new_client('Player 1')
      end

      it 'returns nil' do
        expect(@server.create_room_if_possible).to eq nil
      end
    end

    context 'when there are two players' do
      let(:client1) { MockFishSocketClient.new(@server.port_number) }
      let(:client2) { MockFishSocketClient.new(@server.port_number) }

      before do
        @clients.push(client1)
        @server.accept_new_client('Player 1')
        @clients.push(client2)
        @server.accept_new_client('Player 2')
      end

      it 'sends a ready message to each client' do
        @server.create_room_if_possible
        expect(client1.capture_output).to match (/ready/i)
        expect(client2.capture_output).to match (/ready/i)
      end

      it 'returns a GoFishRoom' do
        expect(@server.create_room_if_possible).to respond_to :game
      end

      it 'adds game to games array' do
        expect {
        @server.create_room_if_possible
      }.to change(@server.rooms, :count).by 1
      end
    end
  end
end