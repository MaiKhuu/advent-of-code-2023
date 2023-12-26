require "../InputParser"

class CityMap
  attr_reader :height, :width, :visited
  
  DIRECTIONS = {"left" => [0, -1], "right" => [0, 1], "up" => [-1, 0], "down" => [1, 0]}
  OPPOSITE_MOVES = {"left" => "right", "right" => "left", "up" => "down", "down" => "up"}
  
  def initialize(arr)
    @height = arr.length
    @width = arr.first.length
    @weights = arr
    @arr = {}
    @height.times do |row|
      @width.times do |col|
        @arr[[row, col]] = [Float::INFINITY, [nil, nil, nil]].clone
      end
    end
    @arr[[0, 0]][0] = 0
    @visited = Set.new(make_tuple([0, 0]))
  end

  def dijsktra
    current_node = [0, 0]
    loop do 
      break if @arr[current_node] == Float::INFINITY
      banned_moves_for_current_node = banned_moves(current_node)
      DIRECTIONS.each do |direction, adjustment| 
        if !banned_moves_for_current_node.include?(direction)
          new_row = current_node[0] + adjustment[0]
          new_col = current_node[1] + adjustment[1]
          if inbound?(new_row, new_col) && @arr[current_node][0] + @weights[new_row][new_col] < @arr[[new_row, new_col]][0]
            next_node = [new_row, new_col]
            add_move(@arr[next_node][1], direction)
            @visited << make_tuple(next_node)
          end
        end
      end
      
      current_node = get_next_node
      p current_node
      gets
      # break
    end
  end

  def get_next_node
    result = nil
    @height.times do |row|
      @width.times do |col|
        p make_tuple([row, col])
        p (@visited.include?(make_tuple([row, col])))
        if !(@visited.include?(make_tuple([row, col])))
          result = [row, col] if result.nil? || @arr[[row, col]][0] < @arr[result][0]
        end
      end
    end
    result
  end

  def add_move(move_arr, new_move)
    move_arr.shift
    move_arr << new_move
  end

  def make_tuple(node_row_col)
    [node_row_col, @arr[node_row_col][0], @arr[node_row_col][1].join(" ")]
  end

  def banned_moves(arr_node)
    result = []
    result << OPPOSITE_MOVES[arr_node[1][2]] 
    result << arr_node[1][2] if arr_node[1][0] == arr_node[1][1] && arr_node[1][0] == arr_node[1][2]
  end

  def inbound?(row, col)
    (0..@height-1).cover?(row) && (0..@width-1).cover?(col)
  end

end

input = InputParser.into_int_array
my_map = CityMap.new(input)
my_map.dijsktra
p my_map.visited