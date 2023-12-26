require "../InputParser"

class Grid
  attr_reader :s_location, :e_location
  DIRECTIONS = [[0, 1], [0, -1], [-1, 0], [1, 0]]

  def initialize(arr)
    @arr = arr
    @height = arr.length
    @width = arr.first.length

    @s_location = [0, arr.first.find_index{ |c| c == "."}]
    @nodes = Set.new([@s_location])
    @direction_count = { @s_location => 1 }
    get_nodes
    @e_location = [@height - 1, arr.last.find_index{ |c| c == "." }]
    @nodes << @e_location

    @graph = {}
    make_graph

    @max = -1 * Float::INFINITY
    @final_path = []
  end

  def make_graph
    @nodes.each { |n| @graph[n] = {} }

    @nodes.each do |node|
      DIRECTIONS.each do |adjustment|
        i, j = node[0] + adjustment[0], node[1] + adjustment[1]
        if inbound?(i, j) && @arr[i][j] != "#"
          previous_i = node[0]
          previous_j = node[1]
          count = 2
          while !@nodes.include?([i, j])
            next_i, next_j = get_next_direction(i, j, previous_i, previous_j)
            previous_i, previous_j = i, j
            i, j = next_i, next_j
            count += 1
          end
          @graph[node][[i, j]] = count if node != [i, j]
        end
      end
    end
  end

  def inbound?(i, j)
    (0..@height - 1).cover?(i) && (0..@width - 1).cover?(j)
  end
  
  def get_nodes
    @height.times do |i|
      @width.times do |j|
        if @arr[i][j] != "#"
          count = 0 
          DIRECTIONS.each do |adjustment|
            new_i = i + adjustment[0]
            new_j = j + adjustment[1]
            count += 1 if inbound?(new_i, new_j) && @arr[new_i][new_j] != "#"
          end
          if count >= 3
            @nodes << [i, j] 
            @direction_count[[i, j]] = count
          end
        end
      end
    end
  end

  def get_next_direction(i, j, previous_i, previous_j)
    DIRECTIONS.each do |adjustment|
      new_i = i + adjustment[0]
      new_j = j + adjustment[1]
      return [new_i, new_j] if [new_i, new_j] != [previous_i, previous_j] &&
                               inbound?(new_i, new_j) && 
                               @arr[new_i][new_j] != "#"
    end
  end

  # def dfs_iterative
  #   stack = [[@s_location, Set.new(), 0]] # node, seen, length
  
  #   until stack.empty?
  #     current, current_seen, current_length = stack.last
  #     # puts "current: #{current}, current length: #{current_length}"
  
  #     if current == @e_location
  #       # puts "max: #{@max}, current length: #{current_length}"
  #       @max = [@max, current_length].max
  #       puts @max
  #       stack.pop
  #     else
  #       if !current_seen.include?(current)
  #         current_seen.add(current)
  
  #         # DIRECTIONS[@arr[current[0]][current[1]]].each do |adjustment|
  #         #   new_row = current[0] + adjustment[0]
  #         #   new_col = current[1] + adjustment[1]
  #         @graph[current].each do |neighbor, length|
  #           # if @arr[new_row][new_col] != "#" && !current_seen.include?([new_row, new_col])
  #           #   stack.push([[new_row, new_col], Set.new(current_seen)])
  #           # end
  #           if !current_seen.include?(neighbor)
  #             stack.push([neighbor, Set.new(current_seen), current_length + length])
  #           end
  #         end
  #       else
  #         stack.pop
  #       end
  #     end
  #   end
  # end

  def dfs(next_step, path, length)
    current_path = path + [next_step]
    current_length = length + @graph[next_step][path.last].to_i
    
    if next_step == @e_location
      if current_length > @max
        @max = current_length
        puts @max
        @final_path = path.clone
      end
      return 
    else
      @graph[next_step].each do |neighbor, _|
        dfs(neighbor, current_path, current_length) if !path.include?(neighbor)
      end
    end
  end

  def part_2
    # dfs_iterative
    dfs(@s_location, [], 0)
    @max - @final_path.length
  end

end

input = Grid.new(InputParser.into_chars_array)
p input.part_2
