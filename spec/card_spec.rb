require 'card'

describe Card do
  let(:card) { Card.new('A', 'H') }

  it 'has a rank' do
    expect(card).to respond_to :rank
  end

  it 'has a suit' do
    expect(card).to respond_to :suit
  end

  describe '#==' do
    it 'compares by rank and suit' do
      card1 = Card.new('A', 'H')
      card2 = Card.new('A', 'H')

      expect(card1).to eq card2
    end
  end
end