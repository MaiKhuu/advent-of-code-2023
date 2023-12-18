require "../InputParser"

class Lagoon
  attr_reader :corners

  DIRECTIONS = { "R" => [0, 1], "L" => [0, -1], "U" => [-1, 0], "D" => [1, 0] }
  def initialize
    @current_location = [0, 0]
    @corners = [[0, 0]]
    @total_edge_lengths = 0
  end

  def add_edge(str)
    direction, count, _ = str.split(" ")
    direction = DIRECTIONS[direction]
    count = count.to_i
    count.times do 
      @current_location = [@current_location[0] + direction[0], @current_location[1] + direction[1]]
    end
    @total_edge_lengths += count
    @corners << @current_location
  end

  def find_area
    @area = 0
    for i in 0..@corners.length - 2
      @area += @corners[i][0] * @corners[i+1][1] - @corners[i][1] * @corners[i+1][0]
    end
    @area.abs / 2 + @total_edge_lengths / 2 + 1
  end

end


my_lagoon = Lagoon.new
InputParser.into_array.each { |line| my_lagoon.add_edge(line) }
p my_lagoon.find_area