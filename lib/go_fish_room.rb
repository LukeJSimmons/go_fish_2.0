require_relative 'go_fish_game'

class GoFishRoom
  attr_reader :clients
  attr_accessor :game, :players
  
  def initialize(clients)
    @game = nil
    @clients = clients
    @players = nil
  end

  def create_game
    self.game = GoFishGame.new
  end

  def create_players
    self.players = {}
    clients.each do |client|
      players[client] = GoFishPlayer.new("Random Player")
    end
  end
  
end