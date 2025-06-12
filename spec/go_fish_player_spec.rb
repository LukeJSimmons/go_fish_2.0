require_relative '../lib/go_fish_player'
require_relative '../lib/card'

describe GoFishPlayer do
    let(:player) { GoFishPlayer.new("name") }
    it 'has a name' do
        expect(player).to respond_to :name
    end

    it 'has a hand' do
      expect(player).to respond_to :hand
    end

    describe '#display_hand' do
      it 'returns a string of cards in hand' do
        expect(player.display_hand).to eq player.hand.join(' ')
      end
    end

    describe '#has_card_of_rank?' do
      context 'when hand does not contain card' do
        it 'returns false' do
          expect(player.has_card_of_rank?('A')).to eq false
        end
      end

      context 'when hand does contain card' do
        it 'returns true' do
            player.hand = [Card.new('A')]
          expect(player.has_card_of_rank?('A')).to eq true
        end
      end
    end
end