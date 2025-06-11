class User
  attr_reader :name, :client, :player

  def initialize(name, client, player)
    @name = name
    @client = client
    @player = player
  end
end