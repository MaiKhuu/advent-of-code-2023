require "../InputParser"

class Dish 
  attr_reader :arr, :rock_only_arr, :ball_count_by_column
  def initialize(arr)
    @arr = turn_90(arr)
    @height = @arr.length
    @width = @arr.first.length
    @width.times { |i| @arr[i] << "#"}
  end

  def turn_90(arr)
    result = []
    arr.first.length.times { result << [] }
    arr.each.with_index do |row, i|
      row.each.with_index do |char, j|
        result [j] = [char] + result[j]
      end
    end
    result
  end
  
  def tilt_north
    result = []
    @arr.each do |row|
      new_row = []
      current_string = []
      row.each do |char|
        if char == "#"
          new_row += current_string.sort
          current_string = []
          new_row << char
        else 
          current_string << char
        end
      end
      result << new_row
    end
    result
  end

  def part_1
    @arr = tilt_north
    @arr.map do |row|
      total = 0
      row.each.with_index do |char, i|
        total += char == "O" ? i + 1 : 0
      end
      total
    end.sum
  end
end

input = Dish.new(InputParser.into_chars_array)
p input.part_1