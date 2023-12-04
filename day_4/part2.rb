require "../InputParser"

class CardsPile
  def initialize(arr)
    @points = arr.map { |str| parse_input_string(str)}
                 .map{ |pair| winning_number_count(pair)}
    @cards_count = Array.new(@points.length).fill(1)
  end

  def tally
    length = @points.length
    @points.each_with_index do |point, idx| 
      point.times do |count|
        @cards_count[(idx + count + 1) % length] += @cards_count[idx]
      end
    end
  end

  def cards_sum
    @cards_count.sum
  end

  def parse_input_string(str)
    result = str.gsub(/Card.+:/, '') 
                .split(" | ")
                .map { |s| s.split(' ')}
                .map{ |arr| arr.map(&:to_i) }
    { "winner" => result.first, "have" => result.last}
  end

  def winning_number_count(pair)
    result = 0
    pair['have'].each do |num|
      result += 1 if pair['winner'].include?(num)
    end
    result
  end
end

input = CardsPile.new(InputParser.into_array)
input.tally
p input.cards_sum
             