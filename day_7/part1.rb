require "../InputParser.rb"

VALUES = { "1" => 1, "2" => 2, "3" => 3, 
           "4" => 4, "5" => 5, "6" => 6,
           "7" => 7, "8" => 8, "9" => 9,
           "T" => 10, "J" => 11, "Q" => 12,
           "K" => 13, "A" => 14}

class Hand
  attr_reader :cards, :bet

  def initialize(str, bet_amount)
    @cards = str.chars.map{ |s| VALUES[s] }
    @bet = bet_amount.to_i
  end

  def calculate_strength
    chars = {}
    result = 0
    @cards.each do |c|
      chars[c] = (chars[c] || 0) + 1
      result += chars[c] - 1
    end
    result
  end

  def <=>(another_hand)
    return -1 if calculate_strength > another_hand.calculate_strength
    return 1 if calculate_strength < another_hand.calculate_strength
    5.times do |i|
      return -1 if cards[i] > another_hand.cards[i]
      return 1 if cards[i] < another_hand.cards[i]
    end
    0
  end
end

hands = InputParser.into_array
                   .map { |str| Hand.new(*str.split(" ")) }
hands.sort! { |a, b| b <=> a}

p hands.map.with_index { |h, i| h.bet * (i + 1) }
       .reduce(&:+)