require 'deck'

describe Deck do
  let(:deck) { Deck.new }
  it 'has cards' do
    expect(deck).to respond_to :cards
  end

  it 'has 52 cards' do
    expect(deck.cards.count).to eq 52
  end

  describe '#draw_card' do
    it 'removes a card from cards' do
      expect {
        deck.draw_card
    }.to change(deck.cards, :count).by (-1)
    end
  end

  describe '#empty?' do
    it 'returns false if cards are not empty' do
      expect(deck.empty?).to eq false
    end

    it 'returns true if cards are empty' do
      deck.cards.clear
      expect(deck.empty?).to eq true
    end
  end
end