require_relative 'card'

class Deck
  attr_reader :cards

  def initialize
    @cards = get_cards
  end

  def draw_card
    cards.pop
  end

  def empty?
    cards.empty?
  end

  def shuffle!
    cards.shuffle!
  end

  def ==(other_deck)
    cards == other_deck.cards
  end

  private

  def get_cards
    Card::RANKS.flat_map do |rank|
      Card::SUITS.map do |suit|
        Card.new(rank, suit)
      end
    end
  end
end