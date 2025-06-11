require 'go_fish_room'
require 'mock_fish_socket_client'
require 'server'

describe GoFishRoom do
  let(:client1) { MockFishSocketClient.new(@server.port_number) }
  let(:client2) { MockFishSocketClient.new(@server.port_number) }

  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    @clients.push(client2)
    @server.accept_new_client('Player 2')
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  let(:room) { GoFishRoom.new([client1, client2]) }
  it 'has a game' do
    expect(room).to respond_to :game
  end

  it 'has clients' do
    expect(room).to respond_to :clients
  end

  describe '#create_game' do
    it 'sets game to GoFishGame' do
      room.create_game
      expect(room.game).to respond_to :deck
    end
  end
end