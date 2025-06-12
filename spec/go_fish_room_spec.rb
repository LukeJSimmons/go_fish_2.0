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
    before do
      client1.provide_input("joe")
      room.run_round
      client1.provide_input("A")
      room.run_round
    end
    it 'runs a round' do
      room.run_game
      expect(client1.capture_output).to match (/requested/i)
    end

    it 'displays the winner' do
      room.run_game
      expect(client1.capture_output).to match (/winner/i)
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

    describe 'resets round state' do
      context 'when round was not finished' do
        before do
          client1.provide_input("joe")
          room.run_round
        end
        
        it 'does not reset the state' do
          expect(room.displayed_hand).to eq true
        end
      end

      context 'when round was fully played' do
        before do
          client1.provide_input("joe")
          room.run_round
          client1.provide_input("A")
          room.run_round
        end

        it 'sets displayed_hand to false' do
          expect(room.displayed_hand).to eq false
        end

        it 'sets asked_for_target to false' do
          expect(room.asked_for_target).to eq false
        end

        it 'sets target to nil' do
          expect(room.target).to eq nil
        end

        it 'sets asked_for_request to false' do
          expect(room.asked_for_request).to eq false
        end

        it 'sets card_request to nil' do
          expect(room.card_request).to eq nil
        end

        it 'sets displayed_results to false' do
          expect(room.displayed_results).to eq false
        end

        it 'sets finished_round to false' do
          expect(room.finished_round).to eq false
        end
      end
    end
  end
end