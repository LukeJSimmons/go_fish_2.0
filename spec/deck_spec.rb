require 'deck'

describe Deck do
  let(:deck) { Deck.new }
  it 'has cards' do
    expect(deck).to respond_to :cards
  end

  it 'has 52 cards' do
    expect(deck.cards.count).to eq 52
  end

  it 'has 4 cards for every rank' do
    expect(deck.cards.group_by(&:rank).all? { |_, cards| cards.count == 4 }).to eq true
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

  describe '#shuffle!' do
    it 'shuffles the deck' do
      unshuffled_deck = Deck.new
      expect(unshuffled_deck).to eq(Deck.new)
      shuffled_deck = unshuffled_deck.shuffle!.dup
      expect(shuffled_deck).to_not eq (unshuffled_deck)
    end
  end
end