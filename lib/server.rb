require 'socket'

require_relative 'go_fish_room'
require_relative 'user'

class Server
  attr_accessor :total_players

  def initialize
    @total_players = 2
  end

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
    create_user(client, player_name)
    client.puts "Welcome!"
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_room_if_possible
    return unless clients.count == total_players
    users.each { |user| user.client.puts users.map(&:name).join(', ') + " we're ready to play!" }
    room = GoFishRoom.new(users)
    # reset_users
    rooms << room
    room
  end

  private

  def request_name_from_client(client)
    client.puts "Please input your name:"
    name = get_client_input(client)
    client.puts "Hey #{name}!"
    name
  end

  def get_client_input(client)
    sleep(0.1)
    begin
      client.read_nonblock(1000).chomp
    rescue IO::WaitReadable, Errno::EAGAIN
      retry
    end
  end

  def create_user(client, player_name)
    player_name ||= request_name_from_client(client)
    player = GoFishPlayer.new(player_name)
    players << player
    users << User.new(player_name, client, player)
  end

  def reset_users
    players.clear
    clients.clear
    users.clear
  end
end