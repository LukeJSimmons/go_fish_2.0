class RoundResult
  attr_reader :current_player, :target, :card_request, :matching_cards, :fished_card

  def initialize(current_player:, target:, card_request:, matching_cards:, fished_card:)
    @current_player = current_player
    @target = target
    @card_request = card_request
    @matching_cards = matching_cards
    @fished_card = fished_card
  end
end