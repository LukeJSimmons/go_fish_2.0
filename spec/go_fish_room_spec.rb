require 'go_fish_room'

describe GoFishRoom do
  let(:room) { GoFishRoom.new }
  it 'has a game' do
    expect(room).to respond_to :game
  end
end