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
    self.game = GoFishGame.new(users.map(&:player))
  end
  
end