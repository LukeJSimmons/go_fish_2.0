class RoundResults
  attr_reader :current_player, :target, :rank, :cards

  def initialize(current_player, target, rank, cards)
    @current_player = current_player
    @target = target
    @rank = rank
    @cards = cards
  end
end