require 'go_fish_game'
require 'go_fish_player'
require 'deck'
require 'card'

describe GoFishGame do
  let(:game) { GoFishGame.new([GoFishPlayer.new('Player 1'),GoFishPlayer.new('Player 2')]) }
  it 'has a deck' do
    expect(game).to respond_to :deck
  end

  it 'has players' do
    expect(game).to respond_to :players
  end

  describe '#current_player' do
    it 'returns a player' do
      expect(game.current_player).to respond_to :name
    end

    context 'when it is the first round' do
      it 'returns the first player' do
        expect(game.current_player).to eq game.players.first
      end
    end

    context 'when it is the second round' do
      it 'returns the first player' do
        game.round += 1
        expect(game.current_player).to eq game.players[1]
      end
    end
  end

  describe '#start' do
    it 'deals cards to each player' do
      game.start
      expect(game.players.all? { |player| player.hand.count == GoFishGame::BASE_HAND_SIZE || player.hand.count == GoFishGame::BASE_HAND_SIZE-4 }).to eq true
    end

    it 'deals cards from deck' do
      expect {
        game.start
      }.to change(game.deck.cards, :count).by (-14)
    end

    it 'shuffles the deck' do
      unshuffled_deck = Deck.new
      expect(game.deck).to eq(unshuffled_deck)
      game.start
      expect(game.deck).to_not eq (unshuffled_deck)
    end
  end

  describe '#winner' do
    before do
      game.start
    end

    context 'when deck is empty and hands are empty' do
      before do
        game.deck.cards.clear
          game.players.each { |player| player.hand.clear }
      end

      context 'when player 1 has the most books' do
        it 'returns player 1' do
          game.players.first.books = [1]
          expect(game.winner.name).to eq 'Player 1'
        end
      end

      context 'when player 2 has the most books' do
        it 'returns player 2' do
          game.players[1].books = [1]
          expect(game.winner.name).to eq 'Player 2'
        end
      end

      context 'when there is a tie for amount of books' do
        context 'when player 1 has highest rank book' do
          before do
            game.players.first.books = ['A']
            game.players.last.books = ['2']
          end

          it 'returns player 1' do
            expect(game.winner.name).to eq 'Player 1'
          end
        end

        context 'when player 2 has highest rank book' do
          before do
            game.players.first.books = ['2']
            game.players.last.books = ['A']
          end

          it 'returns player 2' do
            expect(game.winner.name).to eq 'Player 2'
          end
        end
      end
    end

    context 'when deck is not empty' do
      it 'returns nil' do
        expect(game.winner).to eq nil
      end
    end
  end

  describe '#has_opponent_with_name?' do
    context 'when game does have an opponent with name' do
      let(:game) { GoFishGame.new([GoFishPlayer.new('Player 1'),GoFishPlayer.new('Player 2')]) }

      it 'returns true' do
        expect(game.has_opponent_with_name?('Player 2')).to eq true
      end
    end

    context 'when game does not have an opponent with name' do
      let(:game) { GoFishGame.new([GoFishPlayer.new('Player 1'),GoFishPlayer.new('Player 2')]) }

      it 'returns false' do
        expect(game.has_opponent_with_name?('Player 22')).to eq false
      end
    end
  end

  describe '#get_results' do
    let(:player1) { game.players.first }
    let(:player2) { game.players.last }
    let(:target) { game.players.last.name }

    before do
      game.start
    end

    context 'when target has requested card' do
      before do
        player1.hand = [Card.new('A','H')]
        player2.hand = [Card.new('A','C')]
      end

      it 'removes matching cards from target hand' do
        expect {
          game.get_results(target, 'A')
        }.to change(player2.hand, :count).by (-1)
      end

      it 'adds matching cards to current_player hand' do
        expect {
          game.get_results(target, 'A')
        }.to change(player1.hand, :count).by 1
      end
    end

    context 'when target does not have requested card' do
      before do
        player1.hand = [Card.new('A','H')]
        player2.hand = [Card.new('2','C')]
      end

      it 'adds a card to current_player hand from deck' do
        drawn_card = game.deck.cards.last
        game.get_results(target, 'A')
        expect(player1.hand.first).to eq drawn_card
      end

      context 'when drawn card is not the requested card' do
        before do
          game.deck.cards << Card.new('J','C')
        end

        it 'swaps current_player' do
          game.get_results(target, 'A')
          expect(game.current_player).to eq player2
        end
      end
    end

    it 'returns a round_result' do
      expect(game.get_results(target, 'A')).to respond_to :current_player
    end
  end
end