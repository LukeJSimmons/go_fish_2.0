require 'socket'

require 'go_fish_room'

class Server
  def port_number
    3000
  end

  def clients
    @clients ||= []
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
    client.puts "Welcome!"
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_room_if_possible
    return unless clients.count == 2
    clients.each { |client| client.puts "Ready!" }
    room = GoFishRoom.new(clients)
    clients.clear
    rooms << room
    room
  end
end