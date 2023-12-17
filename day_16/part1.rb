require "../InputParser"

class Mirror
  DIRECTIONS = {
    "|" => { "left" => ["up", "down"], "right" => ["up", "down"], "up" => ["up"], "down" => ["down"] },
    "-" => { "left" => ["left"], "right" => ["right"], "up" => ["left", "right"], "down" => ["left", "right"] },
    "/" => { "left" => ["down"], "right" => ["up"], "up" => ["right"], "down" => ["left"] },
    "\\" => { "left" => ["up"], "right" => ["down"], "up" => ["left"], "down" => ["right"] },
    "." => { "left" => ["left"], "right" => ["right"], "up" => ["up"], "down" => ["down"] },
  }

  attr_reader :row, :col, :char
  def initialize(char, i, j)
    @row = i
    @col = j
    @char = char
    @reflected_direction = DIRECTIONS[char]
  end
  
  def reflect(from_direction)
    @reflected_direction[from_direction]
  end
end

class Beam
  NEXT_COORDINATE = {
    "left" => [0, -1], 
    "right" => [0, 1],
    "up" => [-1, 0],
    "down" => [1, 0]
  }

  attr_accessor :row, :col, :direction
  def initialize(row, col, direction, mirrors_arr)
    @row = row
    @col = col
    @direction = direction
    @mirrors = mirrors_arr
    @max_height = mirrors_arr.length - 1
    @max_width = mirrors_arr.first.length - 1
  end

  def inbound?
    (0..@max_height).cover?(@row) && (0..@max_width).cover?(@col)
  end

  def move
    @row += NEXT_COORDINATE[@direction][0]
    @col += NEXT_COORDINATE[@direction][1]
    if @mirrors[@row] && @mirrors[row][@col]
      next_directions = @mirrors[@row][@col].reflect(@direction)
      @direction = next_directions[0]
      return nil if next_directions.length == 1
      return Beam.new(@row, @col, next_directions[1], @mirrors) if next_directions.length == 2
    else
      return nil 
    end
  end

  def show
    puts "Beam location: [#{@row}, #{col}], direction: #{direction}"
  end
end

class MyArray
  attr_reader :arr, :beams

  def initialize(arr)
    @height = arr.length
    @width = arr.first.length
    @arr = arr.map.with_index do |row, i| 
      row.map.with_index { |char, j| Mirror.new(char, i, j) } 
    end
    @seen = Array.new(@height).map {  Array.new(@width).map { [] } }
    @beams = [Beam.new(0, 0, first_direction, @arr)]
    @seen[0][0] << first_direction
  end

  def first_direction
    case @arr[0][0].char
    when "/"
      "up"
    when "\\"
      "down"
    when "|"
      "down"
    when "-"
      "right"
    when "."
      "right"
    end
  end

  def show
    @height.times do |i|
      puts @arr[i].map { |tile| tile.char }.join("")
    end
  end

  def bounce_beams
    i = 0 
    while i < @beams.length
      current_beam = @beams[i]
      loop do
        new_beam = current_beam.move
        if new_beam
          @seen[new_beam.row][new_beam.col] << new_beam.direction
          @beams << new_beam 
        end
        break if !current_beam.inbound? || @seen[current_beam.row][current_beam.col].include?(current_beam.direction)
        @seen[current_beam.row][current_beam.col] << current_beam.direction
      end
      i += 1
    end
  end

  def show_beams_lines
    @seen.each do |row|
      puts row.map { |arr| arr.empty? ? "." : "#" }.join("")
    end
  end

  def part1
    @seen.map { |row| row.count { |arr| !arr.empty? } }.sum
  end
end

grid = MyArray.new(InputParser.into_chars_array)
grid.bounce_beams
p grid.part1