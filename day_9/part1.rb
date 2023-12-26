require "../InputParser.rb"

class Sequence
  def initialize(str)
    @nums = str.scan(/[-\d]+/).map(&:to_i)
  end

  def find_next
    last_nums = []
    current_nums = @nums.clone

    while !current_nums.all?(&:zero?) do
      last_nums << current_nums.last
      (current_nums.length - 1).times do |i| 
        current_nums[i] = current_nums[i+1] - current_nums[i]
      end
      current_nums.pop
    end
    last_nums.sum
  end
end

input = InputParser.into_array
                   .map{ |str| Sequence.new(str)}
p input.map{ |s| s.find_next }.sum