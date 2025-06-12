require 'go_fish_game'
require 'go_fish_player'

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
  end

  describe '#start' do
    it 'deals cards to each player' do
      game.start
      expect(game.players.all? { |player| player.hand.count >= GoFishGame::BASE_HAND_SIZE }).to eq true
    end

    it 'deals cards from deck' do
      expect {
        game.start
      }.to change(game.deck.cards, :count).by (-14)
    end
  end

  describe '#winner' do
    context 'when deck is empty' do
      it 'returns a player' do
        game.deck.cards.clear
        expect(game.winner).to respond_to :name
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
end