require "../InputParser"

DIRECTIONS = {
  "L" => { [0, 1] => [-1, 0], [-1, 0] => [0, 1]},
  "J" => { [-1, 0] => [0, -1], [0, -1] => [-1, 0]},
  "7" => { [0, -1] => [1, 0], [1, 0] => [0, -1]},
  "F" => { [0, 1] => [1, 0], [1, 0] => [0, 1]},
  "|" => { [-1, 0] => [1, 0], [1, 0] => [-1, 0]},
  "-" => { [0, -1] => [0, 1], [0, 1] => [0, -1]},
  "S" => {},
  "." => {}
}

ZOOMED_IN_TILE = {
  "L" => [%w(. x .), %w(. x x), %w(. . .)], 
  "J" => [%w(. x .), %w(x x .), %w(. . .)], 
  "7" => [%w(. . .), %w(x x .), %w(. x .)], 
  "F" => [%w(. . .), %w(. x x), %w(. x .)], 
  "|" => [%w(. x .), %w(. x .), %w(. x .)], 
  "-" => [%w(. . .), %w(x x x), %w(. . .)], 
  "S" => [%w(x x x), %w(x x x), %w(x x x)], 
  "." => [%w(. . .), %w(. . .), %w(. . .)], 
}

class Tile
  attr_reader :row, :col, :connections, :char

  def initialize(i, j, char)
    @row = i
    @col = j
    @char = char
    @connections = DIRECTIONS[char]
  end

  def go_through(another_tile)
    difference = [@row - another_tile.row, @col - another_tile.col]
    to_go = another_tile.connections[difference]
    return to_go unless to_go
    [another_tile.row + to_go.first, another_tile.col + to_go.last]
  end
end

class MyMap
  attr_reader :map, :s_location, :height, :width

  def initialize(chars_array)
    @s_location = []
    @map = chars_array.map.with_index do |row, i| 
      row.map.with_index do |char, j|
        @s_location = [i, j] if char == "S"
        Tile.new(i, j, char)
      end
    end
    @height = @map.length
    @width = @map.first.length
  end

  def create_visisted_array
    Array.new(@height).map { Array.new(@width).map { false } }
  end

  def inbound?(location)
    location.first >= 0 && location.first < @height &&
    location.last >= 0 && location.last < @width
  end

  def loop_length(second)
    visited = create_visisted_array
    count = 0
    
    first = @s_location

    loop do
      count += 1
      
      first_row, first_col = first.first, first.last
      second_row, second_col = second.first, second.last
      
      return nil, visted if visited[first_row][first_col]
      visited[first_row][first_col] = true
      
      third = @map[first_row][first_col].go_through(@map[second_row][second_col])
      return nil, visited if !third || !inbound?(third)

      if third == @s_location  
        visited[second_row][second_col] = true
        return count + 1, visited
      end

      first = second
      second = third
    end
  end
  
  def get_filled_visited_map
    directions_to_try = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    directions_to_try.each do |next_location|
      going_through_location = [@s_location.first + next_location.first, @s_location.last + next_location.last]
      length, visisted = loop_length(going_through_location)
      return visisted if length
    end
  end
end

class ZoomedInMap
  attr_reader :map
  def initialize(chars, visited)
    org_map = visited.map { |r| r.map { |v| v ? "x" : "." } }
    @map = []
    org_map.length.times do |i|
      3.times { @map << [] }
      org_map.first.length.times do |j|
        char = visited[i][j] ? ZOOMED_IN_TILE[chars[i][j].char] : ZOOMED_IN_TILE["."]
        char.each.with_index { |r, count| @map[i * 3 + count] += r }
      end
    end
    @height = @map.length
    @width = @map.first.length
  end

  def inbound?(row, col)
    row >= 0 && row < @height &&
    col >= 0 && col < @width
  end

  def spread_from_edge
    directions = [[-1, 0], [0, -1], [1, 0], [0, 1]]
    to_be_processed = [[0,0]]

    to_be_processed.each do |location|
      row, col = location
      if @map[row][col] == "."
        @map[row][col] = "e"

        directions.each do |d|
          new_row = row + d.first
          new_col = col + d.last
          to_be_processed << [new_row, new_col] if inbound?(new_row, new_col) && @map[new_row][new_col] == "."
        end
      end

    end
  end

  def perfect_quare?(row, col)
    directions = [[0, 0], [0, 1], [0, 2], [1, 0],  [1, 1], [1, 2], [2, 0], [2, 1], [2, 2] ]
    directions.each do |d|
      new_row = row + d.first
      new_col = col + d.last
      return false if @map[new_row][new_col] != "."
    end
    true
  end

  def mark_square_counted(row, col)
    directions = [[0, 0], [0, 1], [0, 2], [1, 0],  [1, 1], [1, 2], [2, 0], [2, 1], [2, 2] ]
    directions.each do |d|
      new_row = row + d.first
      new_col = col + d.last
      @map[new_row][new_col] != "c"
    end
  end

  def count_squares
    count = 0
    @height.times do |i|
      @width.times do |j|
        if perfect_quare?(i, j) 
          count += 1
          mark_square_counted(i, j)
        end
      end
    end
    count / 9
  end
end

input = InputParser.into_chars_array
input_map = MyMap.new(input)
my_map = ZoomedInMap.new(input_map.map,input_map.get_filled_visited_map)
my_map.spread_from_edge
p my_map.count_squares
