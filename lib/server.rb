require 'socket'

require_relative 'go_fish_room'
require_relative 'user'

class Server
  def port_number
    3000
  end

  def clients
    @clients ||= []
  end

  def players
    @players ||= []
  end

  def users
    @users ||= []
  end

  def rooms
    @rooms ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end

  def accept_new_client(player_name="Random Player")
    sleep 0.1
    client = @server.accept_nonblock
    clients << client
    player = GoFishPlayer.new("name")
    players << player
    users << User.new(client, player)
    client.puts "Welcome!"
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_room_if_possible
    return unless clients.count == 2
    clients.each { |client| client.puts "Ready!" }
    room = GoFishRoom.new(clients, players)
    clients.clear
    rooms << room
    room
  end
end