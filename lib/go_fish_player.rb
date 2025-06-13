class GoFishPlayer
  attr_reader :name
  attr_accessor :hand
  
  def initialize(name)
    @name = name
    @hand = []
  end

  def display_hand
    hand.map(&:rank).join(' ')
  end

  def has_card_of_rank?(rank)
    hand.map(&:rank).include? rank
  end

  def add_card(card)
    hand.unshift(card)
    card
  end
end