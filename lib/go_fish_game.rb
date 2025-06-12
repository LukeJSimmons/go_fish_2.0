require_relative 'deck'
require_relative 'card'

class GoFishGame
  attr_reader :deck, :players

  BASE_HAND_SIZE = 7
  
  def initialize(players)
    @deck = Deck.new
    @players = players
  end

  def current_player
    players.first
  end

  def current_opponents
    players.select { |player| player != current_player }
  end

  def start
    deal_cards
  end

  def winner
    players.first if deck.empty?
  end

  def has_opponent_with_name?(name)
    current_opponents.any? { |opponent| opponent.name == name }
  end

  private

  def deal_cards
    players.each do |player|
      BASE_HAND_SIZE.times do
        player.hand << deck.draw_card
      end
    end
  end
end