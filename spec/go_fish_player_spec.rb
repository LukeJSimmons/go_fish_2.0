require_relative '../lib/go_fish_player'
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
end