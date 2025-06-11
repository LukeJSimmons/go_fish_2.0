require 'socket'

require 'go_fish_game'

class Server
  def port_number
    3000
  end

  def clients
    @clients ||= []
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end

  def accept_new_client(player_name="Random Player")
    client = @server.accept_nonblock
    clients << client
    client.puts "Welcome!"
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_game_if_possible
    return unless clients.count == 2
    clients.each { |client| client.puts "Ready!" }
    game = GoFishGame.new
    games << game
    game
  end
end