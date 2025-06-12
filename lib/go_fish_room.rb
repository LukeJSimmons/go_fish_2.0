require_relative 'go_fish_game'
require_relative 'go_fish_player'

class GoFishRoom
  attr_reader :users
  attr_accessor :game, :displayed_hand, :target, :card_request, :displayed_results
  
  def initialize(users)
    @users = users
    @game = create_game

    @displayed_hand = false
    @target = nil
    @card_request = nil
    @displayed_results = false
  end

  def create_game
    game = GoFishGame.new(users.map(&:player))
    game.start
    game
  end

  def run_game
    run_round
  end

  def run_round
    display_hand unless displayed_hand
    self.target = get_target unless target
    self.card_request = get_card_request if !card_request && target
    display_results unless displayed_results
  end

  private

  def current_user
    users.find { |user| user.player == game.current_player }
  end

  def display_hand
     current_user.client.puts "Your hand is, #{current_user.player.display_hand}"
     self.displayed_hand = true
  end

  def get_target
    current_user.client.puts "Input your target:"
    target = get_client_input(current_user.client)
    current_user.client.puts target
    target
  end

  def get_card_request
    current_user.client.puts "Input your card request:"
    card_request = get_client_input(current_user.client)
    current_user.client.puts card_request
    card_request
  end

  def display_results
    current_user.client.puts "#{current_user.player.name} requested #{card_request} from #{target}"
    self.displayed_results = true
  end

  def get_client_input(client)
    sleep(0.1)
    begin
      client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end