require "../InputParser"

class Garden
  def initialize(arr)
    @arr = arr
    @height = @arr.length
    @width = @arr.first.length
    s_location = get_S
    @current_locations = Set.new([s_location])
    @arr[s_location[0]][s_location[1]] = "."
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
          if inbound?(adjusted_row, adjusted_col) && @arr[adjusted_row][adjusted_col] == "."
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

  def inbound?(row, col)
    (0..@width-1).cover?(col) && (0..@height-1).cover?(row)
  end
  
  def part_1
    walk(64)
    ground_covered
  end
end

input = Garden.new(InputParser.into_chars_array)
p input.part_1