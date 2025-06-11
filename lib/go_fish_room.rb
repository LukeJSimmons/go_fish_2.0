class GoFishRoom
  attr_reader :game, :clients
  
  def initialize(clients)
    @game = nil
    @clients = clients
  end
end