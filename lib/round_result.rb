class RoundResult
  attr_reader :current_player, :target, :card_request, :matching_cards, :fished_card

  def initialize(current_player:, target:, card_request:, matching_cards:, fished_card:)
    @current_player = current_player
    @target = target
    @card_request = card_request
    @matching_cards = matching_cards
    @fished_card = fished_card
  end

  def display_result_message_to(player)
    return target_has_request(player) unless matching_cards.empty?
    return target_does_not_have_request(player)
  end

  private

  def target_has_request(player)
    return "You took #{matching_cards.count} #{card_request}#{multiple_cards?} #{target.name}" if player == :current_player
    "#{current_player.name} took #{matching_cards.count} #{card_request}#{multiple_cards?} #{target.name}"
  end

  def target_does_not_have_request(player)
    return "You requested #{card_request} from #{target.name}, but took nothing\nGo fish, you drew a #{fished_card.rank}" if player == :current_player
    "#{current_player.name} requested #{card_request} from #{target.name}, but took nothing"
  end

  def multiple_cards?
    's' if matching_cards.count > 1
  end
end