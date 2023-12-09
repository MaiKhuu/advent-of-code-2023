require "../InputParser.rb"

def find_next(arr)
  last_num = []
  current_nums = arr.clone
  while !current_nums.all?(&:zero?) do
    last_num << current_nums.first
    (current_nums.length - 1).times do |i| 
      current_nums[i] = current_nums[i+1] - current_nums[i]
    end
    current_nums.pop
  end
  
  last_num.sum
end

input = InputParser.into_array
                   .map{ |str| str.scan(/[-\d]+/)}
                   .map{ |arr| arr.map(&:to_i) }
p input.map{ |arr| find_next(arr) }.sum