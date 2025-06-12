class GoFishPlayer
  attr_reader :name, :hand
  
  def initialize(name)
    @name = name
    @hand = []
  end

  def display_hand
    hand.join(' ')
  end
end