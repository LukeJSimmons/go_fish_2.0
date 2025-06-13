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
    context 'when one round of input is played' do
      before do
        room.game.deck.cards = []
        room.game.current_player.hand = [Card.new('A','D'),Card.new('A','C'),Card.new('A','H')]
        room.game.current_opponents.first.hand = [Card.new('A','S')]
        client1.provide_input("Player 2")
        room.run_round
        client1.provide_input("A")
        room.run_game
      end

      it 'runs a round' do
        expect(client1.capture_output).to match (/requested/i)
      end
    end

    context 'when two rounds of input are played' do
      before do
        room.game.deck.cards = [Card.new('8','S')]
        room.game.players.first.hand = [Card.new('A','H'),Card.new('A','C'),Card.new('A','D'),Card.new('8','H'),Card.new('8','C'),Card.new('8','D')]
        room.game.players[1].hand = [Card.new('A','S')]
        client1.provide_input("Player 2")
        room.run_round
        client1.provide_input("8")
        room.run_round
      end

      it 'runs two rounds' do
        client1.provide_input("Player 2")
        room.run_round
        client1.provide_input("A")
        room.run_game
        expect(client1.capture_output).to match (/requested/i)
      end
    end

    it 'displays the winner' do
      room.game.deck.cards.clear
      room.game.players.first.hand.clear
      room.game.players[1].hand.clear
      room.run_game
      expect(client1.capture_output).to match (/win/i)
    end
  end

  describe '#run_round' do
    describe 'displaying waiting message' do
      it 'display waiting message to current_opponents once' do
        room.run_round
        expect(client2.capture_output).to match (/waiting/i)
        expect(client1.capture_output).to_not match (/waiting/i)

        expect(client2.capture_output).to_not match (/waiting/i)
      end
    end

    describe 'displaying hand' do
      it 'displays sorted hand to current_player' do
        room.run_round
        expect(client1.capture_output).to include room.users.first.player.hand.map(&:rank).sort.join(' ')
        expect(client2.capture_output).to_not include room.users.first.player.hand.map(&:rank).sort.join(' ')
      end
    end

    describe 'getting target' do
      it 'asks for a target' do
        input = "Player 2"
        client1.provide_input(input)
        room.run_round
        expect(client1.capture_output).to match (/target/i)
      end

      it 'displays the inputted target back' do
        input = "Player 2"
        client1.provide_input(input)
        room.run_round
        expect(client1.capture_output).to include input
      end

      context 'when input is invalid' do
        it 'displays error message if input is not a player' do
          input = "joe"
          client1.provide_input(input)
          room.run_round
          expect(client1.capture_output).to match (/invalid/i)
        end

        it 'displays error message if input is the current_player' do
          input = "Player 1"
          client1.provide_input(input)
          room.run_round
          expect(client1.capture_output).to match (/invalid/i)
        end
      end
    end

    describe 'getting card request' do
      before do
        room.users.first.player.hand = [Card.new('A','H')]
        room.users.last.player.hand = [Card.new('A','S')]
        client1.provide_input("Player 2")
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
    end

    describe 'displaying results' do
      before do
        room.users.first.player.hand = [Card.new('A','H')]
        room.users.last.player.hand = [Card.new('A','S')]
        client1.provide_input("Player 2")
        room.run_round
        client1.provide_input("A")
        room.run_round
      end

      it 'displays target and card_request' do
        expect(client1.capture_output).to include "You requested A from Player 2"
        expect(client2.capture_output).to include "Player 1 requested A from Player 2"
      end
    end
  end
end