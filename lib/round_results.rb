class RoundResults
  attr_reader :current_player, :target, :card_request, :cards

  def initialize(current_player, target, card_request, cards)
    @current_player = current_player
    @target = target
    @card_request = card_request
    @cards = cards
  end
end