require_relative 'go_fish_game'
require_relative 'go_fish_player'

class GoFishRoom
  attr_reader :users
  attr_accessor :game, :displayed_hand, :asked_for_target, :target, :asked_for_request, :card_request, :displayed_results, :finished_round
  
  def initialize(users)
    @users = users
    @game = create_game

    @displayed_hand = false
    @asked_for_target = false
    @target = nil
    @asked_for_request = false
    @card_request = nil
    @displayed_results = false
    @finsihed_round = false
  end

  def create_game
    game = GoFishGame.new(users.map(&:player))
    game.start
    game
  end

  def run_game
    loop do
      run_round
    end
  end

  def run_round
    display_hand unless displayed_hand
    self.target = get_target unless target
    self.card_request = get_card_request if !card_request && target
    display_results if !displayed_results && target && card_request
    reset_state if finished_round
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
    current_user.client.puts "Input your target:" unless asked_for_target
    self.asked_for_target = true
    target = get_client_input(current_user.client)
    current_user.client.puts target if target
    target
  end

  def get_card_request
    current_user.client.puts "Input your card request:" unless asked_for_request
    self.asked_for_request = true
    card_request = get_client_input(current_user.client)
    current_user.client.puts card_request if card_request
    card_request
  end

  def display_results
    current_user.client.puts "#{current_user.player.name} requested #{card_request} from #{target}"
    self.displayed_results = true
    self.finished_round = true
  end

  def reset_state
    self.displayed_hand = false
    self.asked_for_target = false
    self.target = nil
    self.asked_for_request = false
    self.card_request = nil
    self.displayed_results = false
    self.finished_round = false
  end

  def get_client_input(client)
    sleep(0.1)
    begin
      client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end