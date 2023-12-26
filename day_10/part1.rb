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
  
  def find_half_loop_length
    directions_to_try = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    directions_to_try.each do |next_location|
      going_through_location = [@s_location.first + next_location.first, @s_location.last + next_location.last]
      length, _ = loop_length(going_through_location)
      return length / 2 if length
    end
  end
end

input = InputParser.into_chars_array
my_map = MyMap.new(input)

p my_map.find_half_loop_length
