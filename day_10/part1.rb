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
  attr_reader :map, :s_location, :height, :width, :visited

  def initialize(chars_array)
    @s_location = []
    @map = chars_array.map.with_index do |row, i| 
      row.map.with_index do |char, j|
        @s_location = [i, j] if char == "S"
        Tile.new(i, j, char)
      end
    end
    @height = @map.length - 1
    @width = @map.first.length - 1
    reset_visited
  end

  def reset_visited
    @visited = []
    (@height + 1).times do |i|
      @visited << []
      (@width + 1).times do |j|
        @visited[i] << false
      end
    end
  end

  def inbound?(location)
    location.first >= 0 && location.first <= @height &&
    location.last >=0 && location.last <= @width
  end

  def is_loop?(starting_location, going_through_location)
    loop do
      @visited[starting_location.first][starting_location.last] = true
      next_up = @map[starting_location.first][starting_location.last].go_through(@map[going_through_location.first][going_through_location.last])
      return true if next_up == @s_location
      return false if next_up.nil? || !inbound?(next_up) || @visited[next_up.first][next_up.last]
      starting_location = going_through_location
      going_through_location = next_up
    end
  end

  def find_loop_length(starting_location, going_through_location)
    count = 1
    loop do
      next_up = @map[starting_location.first][starting_location.last].go_through(@map[going_through_location.first][going_through_location.last])
      count += 1
      return count if next_up == @s_location
      starting_location = going_through_location
      going_through_location = next_up
    end
  end
  
  def find_loop_direction
    directions_to_try = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    directions_to_try.each do |next_location|
      return next_location if is_loop?(@s_location, [@s_location.first + next_location.first, @s_location.last + next_location.last])
      reset_visited
    end
  end
end

input = InputParser.into_chars_array
my_map = MyMap.new(input)

loop_direction = my_map.find_loop_direction
p my_map.find_loop_length(my_map.s_location, [my_map.s_location.first + loop_direction.first, my_map.s_location.last + loop_direction.last]) / 2