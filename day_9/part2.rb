require "../InputParser.rb"

class Sequence
  def initialize(str)
    @nums = str.scan(/[-\d]+/).map(&:to_i)
  end

  def find_first
    first_nums = []
    current_nums = @nums.clone
    
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
end

input = InputParser.into_array
                   .map{ |str| Sequence.new(str)}
p input.map{ |s| s.find_first }.sum