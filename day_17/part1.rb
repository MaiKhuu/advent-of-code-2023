require "../InputParser"

class CityMap
  DIRECTIONS = { "left" => [0, -1], "right" => [0, 1], "up" => [-1, 0], "down" => [1, 0]}
  OPPOSITE_DIRECTIONS = { "left" => "right", "right" => "left", "up" => "down", "down" => "up"}
  
  attr_reader :height, :width, :visited, :nodes
  def initialize(arr)
    @height = arr.length
    @width = arr.first.length
    @weights = arr
    @visited = Set.new
    @nodes = [[0, [0, 0], nil, 0]] 
    # (total, [row, col], direction, direction_counts)
  end

  def djikstra
    loop do
      tuple = get_next_node
      p tuple
      break if tuple.nil?
      
      current_total, current_coord, last_direction, last_direction_count = tuple
      return current_total if current_coord == [@height-1, @width-1]
        
      next if @visited.include?([current_coord, last_direction, last_direction_count])
      
      DIRECTIONS.each do |direction, adjustment|
        if direction != OPPOSITE_DIRECTIONS[last_direction]
          next_coord = [current_coord[0] + adjustment[0], current_coord[1] + adjustment[1]]
          next unless inbound?(next_coord)
          next_total = current_total + @weights[next_coord[0]][next_coord[1]]

          if direction == last_direction && last_direction_count < 3
            @nodes << [next_total, next_coord, last_direction, last_direction_count + 1]
          else 
            @nodes << [next_total, next_coord, direction, 1]
          end
        end
      end
    end
  end

  def get_next_node
    result_idx = nil
    @nodes.each_with_index do |n, i|
      result_idx = i if result_idx.nil? || n[0] < @nodes[result_idx][0]
    end
    return result_idx if result_idx.nil?
    @nodes.delete_at(result_idx)
  end

  def inbound?(node_coords)
    (0..@height-1).cover?(node_coords[0]) && (0..@width-1).cover?(node_coords[1])
  end

  def part1
    p djikstra + @weights[@height - 1][@width - 1]
  end
end

input = InputParser.into_int_array
my_map = CityMap.new(input)
my_map.part1