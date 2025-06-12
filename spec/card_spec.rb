require 'card'

describe Card do
  let(:card) { Card.new('A', 'H') }

  it 'has a rank' do
    expect(card).to respond_to :rank
  end

  it 'has a suit' do
    expect(card).to respond_to :suit
  end
end