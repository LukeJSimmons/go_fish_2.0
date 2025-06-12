class GoFishGame
  attr_reader :deck, :players
  
  def initialize(players)
    @deck = nil
    @players = players
  end

  def current_player
    players.first
  end

  def start
    deal_cards
  end

  private

  def deal_cards
    players.each do |player|
      7.times do
        player.hand << "card"
      end
    end
  end
end