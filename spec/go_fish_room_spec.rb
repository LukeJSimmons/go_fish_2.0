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

  let(:room) { GoFishRoom.new(@server.users) }
  it 'has a game' do
    expect(room).to respond_to :game
  end

  it 'has users' do
    expect(room).to respond_to :users
  end

  describe '#create_game' do
    it 'sets game to GoFishGame' do
      room.create_game
      expect(room.game).to respond_to :deck
    end
  end

  describe '#run_round' do
    it 'displays hand to current_player' do
      room.run_round
      expect(client1.capture_output).to include room.users.first.player.hand.join(' ')
      expect(client2.capture_output).to_not include room.users.first.player.hand.join(' ')
    end
  end
end