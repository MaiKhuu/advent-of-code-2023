require "../InputParser"

class Garden
  def initialize(arr)
    @arr = arr
    @height = @arr.length
    @width = @arr.first.length
    @s_location = get_S
    @arr[@s_location[0]][@s_location[1]] = "."
    reset
  end

  def reset
    @current_locations = Set.new([@s_location])
  end

  def show
    @current_locations.each do |location|
      @arr[location[0]][location[1]] = "O"
    end
    @arr.each do |row|
      puts row.join("")
    end
  end

  def get_S
    @height.times do |i|
      @width.times do |j|
        return [i, j] if @arr[i][j] == "S"
      end
    end
  end

  DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  def walk(step_count)
    step_count.times do
      new_locations = Set.new
      @current_locations.each do |location|
        DIRECTIONS.each do |d|
          adjusted_row = location[0] + d[0]
          adjusted_col = location[1] + d[1]
          calibrated_row = adjusted_row >= 0 ? adjusted_row % @width : @width - 1 - (adjusted_row.abs - 1) % @width
          calibrated_col = adjusted_col >= 0 ? adjusted_col % @height : @height - 1 - (adjusted_col.abs - 1) % @height
          if @arr[calibrated_row][calibrated_col] == "."
            new_locations << [adjusted_row, adjusted_col]
          end
        end
        @current_locations = new_locations
      end
    end
  end

  def ground_covered
    @current_locations.length
  end
  
  def part_1(step_count)
    reset
    walk(step_count)
    ground_covered
  end

  def polynomial_coefficients(point_1, point_2, point_3)
    a = point_1 / 2 - point_2 + point_3 / 2
    b = -3 * (point_1 / 2) + 2 * point_2 - point_3 / 2
    c = point_1 * 1
    return a, b, c
  end

  def part_2(step_count)
    point_1 = part_1(step_count % @height)
    point_2 = part_1(step_count % @height + @height)
    point_3 = part_1(step_count % @height + @height * 2)
    a, b, c = polynomial_coefficients(point_1, point_2, point_3)
    x = (step_count - step_count % @height) / @height
    a * x**2 + b * x + c 
  end
end

input = Garden.new(InputParser.into_chars_array)
p input.part_2(26501365)