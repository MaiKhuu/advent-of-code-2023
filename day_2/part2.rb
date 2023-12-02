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

def max_color(arr, color)
  arr.map{ |bag| bag[color] }.max
end

def power_cube(arr)
  max_color(arr, 'red') *
  max_color(arr, 'green') *
  max_color(arr, 'blue')
end

bags = InputParser.into_array
                  .map { |str| parse_cubes(str) }
p bags.map { |bag| power_cube(bag) }
      .sum

             