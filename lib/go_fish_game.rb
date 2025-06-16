require_relative 'deck'
require_relative 'card'
require_relative 'round_result'

class GoFishGame
  attr_reader :deck, :players
  attr_accessor :round

  BASE_HAND_SIZE = 7
  
  def initialize(players)
    @deck = Deck.new
    @players = players
    @round = 0
  end

  def current_player
    players[round%players.count]
  end

  def current_opponents
    players.select { |player| player != current_player }
  end

  def start
    deck.shuffle!
    deal_cards
  end

  def get_results(target, card_request)
    target = players.find { |player| player.name == target }

    matching_cards = target.hand.select { |card| card.rank == card_request }
    move_cards_from_target_to_player(target, matching_cards)

    fished_card = go_fish if matching_cards.empty?

    result = RoundResult.new(current_player:, target:, card_request:, matching_cards:, fished_card:)

    self.round += 1 if fished_card && fished_card.rank != card_request

    result
  end

  def winner
    player_books_counts = players.map { |player| player.books.count }

    return players[highest_book_index(players.map(&:books))] if player_books_counts.all? { |book_count| book_count == player_books_counts.first } if game_over?

    players[most_books_index(player_books_counts)] if game_over?
  end

  def has_opponent_with_name?(name)
    current_opponents.any? { |opponent| opponent.name == name }
  end

  private

  def deal_cards
    players.each do |player|
      BASE_HAND_SIZE.times do
        player.add_card(deck.draw_card)
      end
    end
  end

  def move_cards_from_target_to_player(target, matching_cards)
    matching_cards.each { |card| target.hand.delete(card) }
    matching_cards.each { |card| current_player.add_card(card) }
  end

  def go_fish
    current_player.add_card(deck.draw_card)
  end

  def game_over?
    deck.empty? && players.all? { |player| player.hand.empty? }
  end

  def most_books_index(books_counts)
    books_counts.find_index(books_counts.max)
  end

  def highest_book_index(books)
    book_ranks = books.map { |book| Card::RANKS.find_index(book.first) }
    book_ranks.find_index(book_ranks.max)
  end
end