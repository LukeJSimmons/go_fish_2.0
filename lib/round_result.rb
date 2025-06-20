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
    message = "#{player == :current_player ? "You" : current_player.name} requested #{card_request} from #{target.name},\n"
    message += target_has_request(player) unless matching_cards.empty?
    message += target_does_not_have_request(player) if matching_cards.empty?
    message += player_got_book(player)
    message
  end

  private

  def target_has_request(player)
    return "and you took #{matching_cards.count} #{card_request}#{multiple_cards?} from #{target.name}" if player == :current_player
    "#{current_player.name} took #{matching_cards.count} #{card_request}#{multiple_cards?} #{target.name}"
  end

  def target_does_not_have_request(player)
    "but they didn't have any.\n#{go_fish if player == :current_player}"
  end

  def go_fish
    return "But you fished a #{fished_card.rank}!" if fished_card && fished_card.rank == card_request
    return "You fished a #{fished_card.rank}" if fished_card
    "The deck is empty!"
  end

  def player_got_book(player)
    return "\nYou got a book of #{card_request}s!" if current_player.books.any? { |book| book.first.rank == card_request } if card_request
    return "\nYou got a book of #{fished_card.rank}s!" if current_player.books.any? { |book| book.first.rank == fished_card.rank } if fished_card
    ""
  end

  def multiple_cards?
    's' if matching_cards.count > 1
  end
end