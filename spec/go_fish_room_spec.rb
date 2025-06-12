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

  describe '#run_game' do
    xit 'runs a round' do
      room.run_game
      expect(client1.capture_output).to match (/results/i)
    end
  end

  describe '#run_round' do
    describe 'displaying hand' do
      it 'displays hand to current_player' do
        room.run_round
        expect(client1.capture_output).to include room.users.first.player.hand.join(' ')
        expect(client2.capture_output).to_not include room.users.first.player.hand.join(' ')
      end
    end

    describe 'getting target' do
      it 'asks for a target' do
        room.run_round
        expect(client1.capture_output).to match (/target/i)
      end

      it 'displays the inputted target back' do
        input = "joe"
        client1.provide_input(input)
        room.run_round
        expect(client1.capture_output).to include input
      end

      it 'sets target to inputted target' do
        input = "joe"
        client1.provide_input(input)
        room.run_round
        expect(room.target).to eq input
      end
    end

    describe 'getting card request' do
      before do
        client1.provide_input("joe")
        room.run_round
      end

      it 'asks for a card request' do
        room.run_round
        expect(client1.capture_output).to match (/request/i)
      end

      it 'displays the inputted card request back' do
        input = "A"
        client1.provide_input(input)
        room.run_round
        expect(client1.capture_output).to include input
      end

      it 'sets card_request to inputted card request' do
        input = "A"
        client1.provide_input(input)
        room.run_round
        expect(room.card_request).to eq input
      end
    end

    describe 'displaying results' do
      before do
        client1.provide_input("joe")
        room.run_round
        client1.provide_input("A")
      end

      it 'displays target and card_request' do
        room.run_round
        expect(client1.capture_output).to include "Player 1 requested A from joe"
      end
    end
  end
end