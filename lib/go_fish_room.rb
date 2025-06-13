require_relative 'go_fish_game'
require_relative 'go_fish_player'
require_relative 'round_result'

class GoFishRoom
  attr_reader :users
  attr_accessor :game, :displayed_waiting, :displayed_hand, :asked_for_target, :target, :asked_for_request, :card_request, :displayed_results, :finished_round
  
  def initialize(users)
    @users = users
    @game = create_game
  end

  def create_game
    game = GoFishGame.new(users.map(&:player))
    game.start
    game
  end

  def run_game
    until game.winner
      run_round
    end
  end

  def run_round
    display_waiting unless displayed_waiting
    display_hand unless displayed_hand
    get_target unless target
    get_card_request if target
    results = game.get_results(target, card_request) if target && card_request
    display_results(results) if !displayed_results && results
    reset_state if finished_round
  end

  private

  def current_user
    users.find { |user| user.player == game.current_player }
  end

  def opponent_users
    users.select { |user| user.player != game.current_player }
  end

  def display_waiting
    opponent_users.each { |opponent| opponent.client.puts "Waiting for #{current_user.player.name} to finish their turn..." }
    self.displayed_waiting = true
  end

  def display_hand
     current_user.client.puts "Your hand is, #{current_user.player.display_hand}"
     self.displayed_hand = true
  end

  def get_target
    current_user.client.puts "Input your target:" unless asked_for_target
    self.asked_for_target = true
    self.target = get_client_input(current_user.client)
    current_user.client.puts target if target
    return target if game.has_opponent_with_name?(target)

    current_user.client.puts "Invalid input:" if target
    self.target = nil
  end

  def get_card_request
    current_user.client.puts "Input your card request:" unless asked_for_request
    self.asked_for_request = true
    self.card_request = get_client_input(current_user.client)
    current_user.client.puts card_request if card_request
    return card_request if current_user.player.has_card_of_rank?(card_request)
    
    current_user.client.puts "Invalid input:" if card_request
    self.card_request = nil
  end

  def display_results(result)
    users.find { |user| user.player == result.current_player }.client.puts result.display_result_message_to(:current_player)
    users.select { |user| user.player != result.current_player }.each { |opponent| opponent.client.puts result.display_result_message_to(:opponent) }
    self.displayed_results = true
    self.finished_round = true
  end

  def reset_state
    self.displayed_waiting = false
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