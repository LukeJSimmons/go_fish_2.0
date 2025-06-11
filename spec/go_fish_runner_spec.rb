require 'go_fish_runner'

describe GoFishRunner do
  let(:runner) { GoFishRunner.new }
  it 'has a game' do
    expect(runner).to respond_to :game
  end
end