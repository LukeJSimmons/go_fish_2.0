require_relative 'server'

server = Server.new
server.start
puts "#{server} started on port #{server.port_number}"
loop do
  server.accept_new_client
  room = server.create_room_if_possible
  if room
    room.run_game
  end
rescue StandardError
  server.stop
end
