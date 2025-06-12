require_relative 'go_fish_game'
require_relative 'go_fish_player'

class GoFishRoom
  attr_reader :users
  attr_accessor :game
  
  def initialize(users)
    @users = users
    @game = create_game
  end

  def create_game
    game = GoFishGame.new(users.map(&:player))
    game.start
    game
  end

  def run_round
    display_hand
  end

  private

  def current_user
    users.find { |user| user.player == game.current_player }
  end

  def display_hand
     current_user.client.puts "Your hand is: #{current_user.player.display_hand}"
  end
end