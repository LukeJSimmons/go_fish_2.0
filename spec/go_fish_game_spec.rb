require 'go_fish_game'
require 'go_fish_player'

describe GoFishGame do
  let(:game) { GoFishGame.new([GoFishPlayer.new('Player')]) }
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
      expect(game.players.all? { |player| player.hand.count >= 7 }).to eq true
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
end