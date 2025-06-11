require 'go_fish_game'

describe GoFishGame do
  let(:game) { GoFishGame.new([]) }
  it 'has a deck' do
    expect(game).to respond_to :deck
  end

  it 'has players' do
    expect(game).to respond_to :players
  end
end