class GoFishPlayer
  attr_reader :name
  attr_accessor :hand, :books
  
  def initialize(name)
    @name = name
    @hand = []
    @books = []
  end

  def display_hand
    hand.map(&:rank).join(' ')
  end

  def has_card_of_rank?(rank)
    hand.map(&:rank).include? rank
  end

  def add_card(card)
    hand.unshift(card)
    check_for_book
    card
  end

  private
  
  def check_for_book
    book = hand.group_by(&:rank).values.find { |cards| cards.count == 4 }
    book.each { |card| hand.delete(card) if book.include? card } if book
    self.books << book if book
  end
end