require_relative 'server'

server = Server.new
server.start
puts "#{server} started on port #{server.port_number}"
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  if game
    
  end
rescue StandardError
  server.stop
end
