class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank.to_s.capitalize} of #{suit.capitalize}"
  end

  def ==(other)
    rank == other.rank and suit == other.suit
  end
end

class Deck
  class Hand
    attr_reader :cards

    def initialize(cards)
      @cards = cards
    end

    def size
      cards.size
    end
  end

  include Enumerable

  attr_reader :cards

  def initialize(cards = nil)
    @cards = cards || default_deck
  end

  def size
    cards.size
  end

  def draw_top_card
    cards.shift
  end

  def draw_bottom_card
    cards.pop
  end

  def top_card
    cards.first
  end

  def bottom_card
    cards.last
  end

  def shuffle
    cards.shuffle!
  end

  def sort
    cards.sort_by! do |card|
      [suits.find_index(card.suit), ranks.find_index(card.rank)]
    end.reverse!
  end

  def to_s
    cards.map(&:to_s).join("\n")
  end

  def each
    cards.each { |card| yield card }
  end

  def deal
    self.class::Hand.new(cards.shift(self.class::Hand::INITIAL_SIZE))
  end

  private

  def suits
    self.class::SUITS
  end

  def ranks
    self.class::RANKS
  end

  def default_deck
    suits.product(ranks).map { |suit, rank| Card.new(rank, suit) }
  end
end

class WarDeck < Deck
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

  class Hand < Deck::Hand
    INITIAL_SIZE = 26

    def play_card
      cards.pop
    end

    def allow_face_up?
      size < 4
    end
  end
end

class BeloteDeck < Deck
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [7, 8, 9, 10, :jack, :queen, :king, :ace]

  class Hand < Deck::Hand
    INITIAL_SIZE = 8

    def highest_of_suit(suit)
      cards.select { |card| card.suit == suit }.max_by do |card|
        RANKS.find_index card.rank
      end
    end

    def belote?
      cards.group_by(&:suit).values.any? do |suit|
        suit.any? { |card| card.rank == :king} and
        suit.any? { |card| card.rank == :queen}
      end
    end

    def tierce?
      has_consecutive_cards?(3)
    end

    def quarte?
      has_consecutive_cards?(4)
    end

    def quint?
      has_consecutive_cards?(5)
    end

    def carre_of_jacks?
      four_of_a_kind?(:jack)
    end

    def carre_of_nines?
      four_of_a_kind?(9)
    end

    def carre_of_aces?
      four_of_a_kind?(:ace)
    end

    private

    def four_of_a_kind?(rank)
      cards.count { |card| card.rank == rank } == 4
    end

    def has_consecutive_cards?(number_of_cards)
      cards.combination(number_of_cards).any? do |combination|
        consecutive?(combination)
      end
    end

    private

    def consecutive?(cards)
      same_suit?(cards) and consecutive_ranks?(cards)
    end

    def same_suit?(cards)
      cards.map(&:suit).uniq.size == 1
    end

    def consecutive_ranks?(cards)
      sorted_ranks = cards.map { |card| RANKS.find_index(card.rank) }.sort
      sorted_ranks.each_cons(2).all? do |first_rank, second_rank|
          first_rank.next == second_rank
      end
    end
  end
end

class SixtySixDeck < Deck
  SUITS = [:clubs, :diamonds, :hearts, :spades]
  RANKS = [9, 10, :jack, :queen, :king, :ace]

  class Hand < Deck::Hand
    INITIAL_SIZE = 6

    def twenty?(trump_suit)
      (SUITS - [trump_suit]).any? { |suit| king_and_queen_of_suit?(suit) }
    end

    def forty?(trump_suit)
      king_and_queen_of_suit?(trump_suit)
    end

    private

    def king_and_queen_of_suit?(suit)
      cards.any? { |card| card.suit == suit and card.rank == :queen } and
      cards.any? { |card| card.suit == suit and card.rank == :king }
    end
  end
end