require '../InputParser'

def parse_cubes(str)
  arr = str.gsub(/Game [0-9]*: /, '')
     .split(";")
  arr.map do |str|
    result = {}
    result["red"] = str.scan(/[0-9]+ red/).first.to_i
    result["blue"] = str.scan(/[0-9]+ blue/).first.to_i
    result["green"] = str.scan(/[0-9]+ green/).first.to_i
    result
  end 
end

def valid_game?(arr)
  arr.all? do |bag| 
    bag['red'] <= 12 && 
    bag['green'] <= 13 &&
    bag['blue'] <= 14
  end
end

bags = InputParser.into_array
                  .map { |str| parse_cubes(str) }
p bags.map
      .with_index { |bag, index| valid_game?(bag) ? index + 1 : 0}
      .sum

             