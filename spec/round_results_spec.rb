require 'round_results'

describe RoundResults do
  let(:results) { RoundResults.new('player','target','card_request',[]) }

  it 'has a current_player' do
    expect(results).to respond_to :current_player
  end

  it 'has a target' do
    expect(results).to respond_to :target
  end

  it 'has a card_request' do
    expect(results).to respond_to :card_request
  end

  it 'has cards' do
    expect(results).to respond_to :cards
  end
end