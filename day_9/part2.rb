require "../InputParser.rb"

def find_next(arr)
  first_nums = []
  current_nums = arr.clone
  while !current_nums.all?(&:zero?) do
    first_nums << current_nums.first
    (current_nums.length - 1).times do |i| 
      current_nums[i] = current_nums[i+1] - current_nums[i]
    end
    current_nums.pop
  end

  first_nums.reverse!
  extrapolated_num = 0
  (first_nums.length).times do |i|
    extrapolated_num = first_nums[i] - extrapolated_num
  end

  extrapolated_num
end

input = InputParser.into_array
                   .map{ |str| str.scan(/[-\d]+/)}
                   .map{ |arr| arr.map(&:to_i) }
p input.map{ |arr| find_next(arr) }.sum