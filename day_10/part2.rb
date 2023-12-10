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

ZOOMED_IN_TILE_CHARS = {
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
  attr_reader :map, :s_location, :height, :width, :visited, :ground_map

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
      if next_up == @s_location
        @visited[going_through_location.first][going_through_location.last] = true
        return true 
      end
      return false if next_up.nil? || !inbound?(next_up) || @visited[next_up.first][next_up.last]
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

class ZoomedInMap
  attr_reader :map
  def initialize(my_map)
    @map = []
    (my_map.height + 1).times do |i|
      (my_map.width + 1).times do |j|
        char = if my_map.visited[i][j]
          ZOOMED_IN_TILE_CHARS[my_map.map[i][j].char]
        else
          ZOOMED_IN_TILE_CHARS["."]
        end
        3.times do |count|
          @map[i * 3 + count] = (@map[i * 3 + count] || []) + char[count]
        end
      end
    end

    @height = @map.length
    @width = @map.first.length
  end

  def inbound?(row, col)
    row >= 0 && row <= @height - 1 &&
    col >= 0 && col <= @width - 1
  end
  

  def spread_from_edge
    directions = [[-1, 0], [0, -1], [1, 0], [0, 1]]
    arr = [[0,0]]

    arr.each do |cell|
      row = cell.first
      col = cell.last

      if @map[row][col] == "."
        @map[row][col] = "e"

        directions.each do |d|
          new_row = row + d.first
          new_col = col + d.last
          arr << [new_row, new_col] if inbound?(new_row, new_col) && @map[new_row][new_col] == "."
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
    count
  end
  
end

input = InputParser.into_chars_array
my_map = MyMap.new(input)

loop_direction = my_map.find_loop_direction
my_map.is_loop?(my_map.s_location, loop_direction)

zoomed_in_map = ZoomedInMap.new(my_map)

zoomed_in_map.spread_from_edge
p zoomed_in_map.count_squares / 9
