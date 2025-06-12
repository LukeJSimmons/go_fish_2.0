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

  private

  def get_cards
    Array.new(52, 'A')
  end
end