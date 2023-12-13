require "../InputParser"

class Pattern
  attr_accessor :arr

  def initialize(chunk)
    @arr = chunk.split("\n")
    @height = @arr.length
    @width = @arr.first.length
  end

  def potential_vertical_mirror?
    (@width-1).times do |i|
      return i if is_potentially_verticaly_reflective_at(i)
    end
    nil
  end

  def is_potentially_verticaly_reflective_at(column_idx)
    left_length = column_idx + 1
    right_length = @width - left_length
    min_length = [left_length, right_length].min
    smudge_column_found = false
    @arr.each do |row|
      if row[left_length-min_length..left_length-1] != row[left_length..left_length+min_length-1].reverse
        return false if smudge_column_found 
        return false unless two_halves_single_difference(row[left_length-min_length..left_length-1], row[left_length..left_length+min_length-1].reverse)
        smudge_column_found = true
      end
    end
    smudge_column_found
  end

  def two_halves_single_difference(half1, half2)
    difference_count = 0
    half1.length.times do |i|
      if half1[i] != half2[i]
        difference_count += 1
        return false if difference_count > 1
      end
    end
    difference_count == 1
  end

  def potential_horizontal_mirror?
    (@height-1).times do |i|
      return i if is_potentially_horizontally_reflective_at(i)
    end
    nil
  end

  def is_potentially_horizontally_reflective_at(row_idx)
    gap = 0
    smudge_row_found = false
    while row_idx - gap >= 0 && row_idx + 1 + gap < @height do
     if @arr[row_idx - gap] != @arr[row_idx + 1 + gap]
      return false if smudge_row_found
      return false unless rows_single_difference(row_idx - gap, row_idx + 1 + gap)
      smudge_row_found = true
     end
      gap += 1
    end
    smudge_row_found
  end

  def rows_single_difference(i1, i2)
    difference_count = 0
    @width.times do |j|
      difference_count += 1 if @arr[i1][j] != @arr[i2][j]
      return false if difference_count > 1
    end
    difference_count == 1
  end

  def part_2
    vertical_line = potential_vertical_mirror?
    horizontal_line = potential_horizontal_mirror?
    return vertical_line + 1 if vertical_line
    return (horizontal_line + 1) * 100 if horizontal_line
  end
end

input = InputParser.into_chunks.map{ |c| Pattern.new(c) }
p input.map { |p| p.part_2 }.sum