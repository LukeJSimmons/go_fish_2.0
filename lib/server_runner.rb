require_relative 'server'

server = Server.new
server.start
puts "#{server} started on port #{server.port_number}"
puts "How many players would you like in your game?"
server.total_players = gets.chomp.to_i
loop do
  server.accept_new_client
  room = server.create_room_if_possible
  if room
    room.run_game
  end
rescue StandardError
  server.stop
end
