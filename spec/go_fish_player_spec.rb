require_relative '../lib/go_fish_player'
describe GoFishPlayer do
    let(:player) { GoFishPlayer.new("name") }
    it 'has a name' do
        expect(player).to respond_to :name
    end
end