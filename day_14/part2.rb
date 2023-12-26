require "../InputParser"

class Dish 
  attr_reader :arr
  def initialize(arr)
    @arr = arr.map { |row| ["#"] + row + ["#"] }
    new_rock_row = ["#"] * @arr.first.length
    @arr = [new_rock_row] + @arr + [new_rock_row]
    @memo = {}
  end

  def part_2
    count = 0
    cycle_found = nil

    while count <= 1000000000
      cycle 
      if @memo[arr_string] && !cycle_found
        cycle_found = count - @memo[arr_string]
        count += cycle_found until count > 1000000000
        count -= cycle_found
        count += 2
      else
        @memo[arr_string] = count
        count += 1
      end
    end 

    get_support_beam
  end

  def arr_string
    @arr.map { |row| row.join("")}.join("")
  end

  def turn_90_right(arr)
    rows, cols = arr.length, arr[0].length
    result = Array.new(cols) { Array.new(rows) }
    (0...rows).each do |i|
      (0...cols).each do |j|
        result[j][rows - 1 - i] = arr[i][j]
      end
    end
    result
  end

  def turn_90_left(arr)
    rows, cols = arr.length, arr[0].length
    result = Array.new(cols) { Array.new(rows) }  
    (0...rows).each do |i|
      (0...cols).each do |j|
        result[cols - 1 - j][i] = arr[i][j]
      end
    end
    result
  end
  
  def tilt_north(arr)
    new_arr = turn_90_right(arr)
    result = tilt_east(new_arr)
    turn_90_left(result)
  end

  def tilt_east(arr)
    result = []
    arr.each do |row|
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

  def tilt_west(arr)
    new_arr = turn_90_right(turn_90_right(arr))
    result = tilt_east(new_arr)
    turn_90_left(turn_90_left(result))
  end

  def tilt_south(arr)
    new_arr = turn_90_left(arr)
    result = tilt_east(new_arr)
    turn_90_right(result)
  end

  def cycle
    @arr = tilt_east(tilt_south(tilt_west(tilt_north(@arr))))
  end

  def get_support_beam
    @arr = turn_90_right(@arr)
    result = @arr.map do |row|
      total = 0
      row.each.with_index do |char, i|
        total += char == "O" ? i : 0
      end
      total
    end.sum
    @arr = turn_90_left(@arr)
    result
  end
end

input = Dish.new(InputParser.into_chars_array)
p input.part_2