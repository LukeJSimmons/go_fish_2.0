require_relative 'deck'
require_relative 'card'

class GoFishGame
  attr_reader :deck, :players
  
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
      7.times do
        player.hand << Card.new('A','H')
      end
    end
  end
end