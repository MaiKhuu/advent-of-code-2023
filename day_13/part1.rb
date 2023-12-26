require "../InputParser"

class Pattern
  attr_accessor :arr

  def initialize(chunk)
    @arr = chunk.split("\n")
    @height = @arr.length
    @width = @arr.first.length
  end

  def vertical_mirror?
    (@width-1).times do |i|
      return i if is_verticaly_reflective_at(i)
    end
    nil
  end

  def is_verticaly_reflective_at(column_idx)
    left_length = column_idx + 1
    right_length = @width - left_length
    min_length = [left_length, right_length].min
    @arr.each do |row|
      return false unless row[left_length-min_length..left_length-1] == row[left_length..left_length+min_length-1].reverse
    end
    true
  end

  def horizontal_mirror?
    (@height-1).times do |i|
      return i if is_horizontally_reflective_at(i)
    end
    nil
  end

  def is_horizontally_reflective_at(row_idx)
    gap = 0
    while row_idx - gap >= 0 && row_idx + 1 + gap < @height do
      return false unless @arr[row_idx - gap] == @arr[row_idx + 1 + gap]
      gap += 1
    end
    true
  end

  def part_1
    vertical_line = vertical_mirror?
    horizontal_line = horizontal_mirror?
    return vertical_line + 1 if vertical_line
    return (horizontal_line + 1) * 100 if horizontal_line
  end
end

input = InputParser.into_chunks.map{ |c| Pattern.new(c) }
p input.map { |p| p.part_1 }.sum