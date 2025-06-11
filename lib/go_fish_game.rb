class GoFishGame
  attr_reader :deck, :players
  
  def initialize(players)
    @deck = nil
    @players = players
  end
end