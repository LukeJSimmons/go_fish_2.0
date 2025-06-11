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

  def accept_new_client(player_name=nil)
    sleep 0.1
    client = @server.accept_nonblock
    clients << client
    player_name ||= request_name_from_client(client)
    player = GoFishPlayer.new(player_name)
    players << player
    users << User.new(player_name, client, player)
    client.puts "Welcome!"
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_room_if_possible
    return unless clients.count == 2
    users.each { |user| user.client.puts users.map(&:name).join(', ') + " we're ready to play!" }
    room = GoFishRoom.new(users)
    clients.clear
    rooms << room
    room
  end

  private

  def request_name_from_client(client)
    client.puts "Please input your name:"
    name = nil
    name = get_client_input(client) until name
    client.puts "Hey #{name}!"
    name
  end

  def get_client_input(client)
    sleep(0.1)
    begin
      client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end