require "../InputParser"

class CityMap
  attr_reader :graph, :visited, :previous_move, :previous_node, :total, :height, :width
  def initialize(arr)
    @height = arr.length
    @width = arr.first.length
    make_graph_visited_previous_node_previous_move_total_weights(arr)
  end

  def make_graph_visited_previous_node_previous_move_total_weights(arr)
    @graph = {}
    @visited = {}
    @previous_node = {}
    @previous_move = {}
    @total = {}
    @weights = {}
    
    @height.times do |row|
      @width.times do |col|
        @visited[[row, col]] = false
        @previous_node[[row, col]] = nil
        @previous_move[[row, col]] = nil
        @weights[[row, col]] = arr[row][col]
        @total[[row, col]] = Float::INFINITY
        
        @graph[[row, col]] = {}

        new_col = col - 1
        @graph[[row, col]]["left"] = [row, new_col] if inbound?(row, new_col)
        new_col = col + 1
        @graph[[row, col]]["right"] = [row, new_col] if inbound?(row, new_col)
        new_row = row - 1
        @graph[[row, col]]["up"] = [new_row, col] if inbound?(new_row, col)
        new_row = row + 1
        @graph[[row, col]]["down"] = [new_row, col] if inbound?(new_row, col)
      end
    end
  end

  def inbound?(row, col)
    (0..@height-1).cover?(row) && (0..@width-1).cover?(col)
  end

  def mark_starting_node(row, col)
    @previous_move[[row, col]] = ""
    @previous_node[[row, col]] = [row, col]
    @total[[row, col]] = 0
  end

  def dijsktra(starting_row, starting_col)
    mark_starting_node(starting_row, starting_col)

    current_node = [starting_row, starting_col]
    until current_node.nil?
      # p current_node
      @visited[current_node] = true
      banned_directions = not_allowed_directions(current_node)
      @graph[current_node].each do |direction, neighbor_node|
        
        if !@visited[neighbor_node] && 
           !banned_directions.include?(direction) &&
            @total[current_node] + @weights[neighbor_node] < @total[neighbor_node]
          
          @total[neighbor_node] = @total[current_node] + @weights[neighbor_node]
          @previous_node[neighbor_node] = current_node
          @previous_move[neighbor_node] = direction

        end
      end
      current_node = get_min_unvisted_node
      break if current_node.nil?
    end
  end

  def not_allowed_directions(node)
    previous_move = @previous_move[node]
    previous_previous_move = @previous_move[@previous_node[node]]
    previous_previous_previous_move = @previous_move[@previous_node[@previous_node[node]]]
    
    result = case previous_move
              when "left"
                ["right"]
              when "right"
                ["left"]
              when "up"
                ["down"]
              when "down"
                ["up"]
              else 
                []
              end
    
    result << previous_move if previous_move == previous_previous_move && previous_previous_move == previous_previous_previous_move
    result
  end

  def get_min_unvisted_node
    min_node = nil
    @total.each do |k, v|
      min_node = k if !visited[k] && (min_node.nil? || v < @total[min_node])
    end
    min_node
  end

  def get_path
    node = [@height - 1, @width - 1]
    loop do
      puts "node: #{node}, previous move: #{@previous_move[node]}"
      break if node == [0,0]
      node = @previous_node[node]
    end
  end
end

input = InputParser.into_int_array
my_map = CityMap.new(input)
# p my_map.graph
my_map.dijsktra(0, 0)
# p my_map.previous_move
# p my_map.total
puts
my_map.get_path
p my_map.total[[my_map.height - 1,my_map.width - 1]]