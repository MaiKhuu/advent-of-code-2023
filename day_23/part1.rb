require "../InputParser"

class Grid
  attr_reader :s_location, :e_location

  DIRECTIONS = { "." => [[0, -1], [0, 1], [-1, 0], [1, 0]], 
  ">" => [[0, 1]], 
  "<" => [[0, -1]],
  "^" => [[-1, 0]],
  "v" => [[1, 0]], 
  "S" => [[1, 0]] }

  def initialize(arr)
    @arr = arr
    @height = arr.length
    @width = arr.first.length
    @s_location = [0, arr.first.find_index{ |c| c == "."}]
    @arr[@s_location[0]][@s_location[1]] = "S"

    @e_location = [@height - 1, arr.last.find_index{ |c| c == "."}]
    @arr[@e_location[0]][@e_location[1]] = "E"
    @max = -1 * Float::INFINITY
  end
  
  def dfs_iterative
    stack = [[@s_location, Set.new()]]
  
    until stack.empty?
      current, current_seen = stack.last
  
      if current == @e_location
        @max = [@max, current_seen.length].max
        stack.pop
      else
        if !current_seen.include?(current)
          current_seen.add(current)
  
          DIRECTIONS[@arr[current[0]][current[1]]].each do |adjustment|
            new_row = current[0] + adjustment[0]
            new_col = current[1] + adjustment[1]
  
            if @arr[new_row][new_col] != "#" && !current_seen.include?([new_row, new_col])
              stack.push([[new_row, new_col], Set.new(current_seen)])
            end
          end
        else
          stack.pop
        end
      end
    end
  end
  

  def part_1
    dfs_iterative
    @max
  end
end

input = Grid.new(InputParser.into_chars_array)
p input.part_1