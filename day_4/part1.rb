require "../InputParser"

class CardsPile
  def initialize(arr)
    @nums_pairs = arr.map { |str| parse_input_string(str)}
  end

  def calculate_points
    @nums_pairs.map { |pair| winning_number_count(pair)}
               .map { |winning_count| calc_points(winning_count)}
               .sum
  end

  def parse_input_string(str)
    result = str.gsub(/Card.+:/, '') 
                .split(" | ")
                .map { |s| s.split(' ')}
                .map{ |arr| arr.map(&:to_i) }
    { "winner" => result.first, "have" => result.last}
  end

  def calc_points(winning_count)
    winning_count == 0 ? 0 : 2**(winning_count - 1)
  end

  def winning_number_count(pair)
    result = 0
    pair['have'].each do |num|
      result += 1 if pair['winner'].include?(num)
    end
    result
  end
end

p CardsPile.new(InputParser.into_array).calculate_points
             