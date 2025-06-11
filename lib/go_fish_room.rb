require 'go_fish_game'

class GoFishRoom
  attr_reader :clients
  attr_accessor :game
  
  def initialize(clients)
    @game = nil
    @clients = clients
  end

  def create_game
    self.game = GoFishGame.new
  end
end