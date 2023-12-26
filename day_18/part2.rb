require "../InputParser"

class Lagoon
  attr_reader :corners

  DIRECTIONS = { "0" => [0, 1], "2" => [0, -1], "3" => [-1, 0], "1" => [1, 0] }
  def initialize
    @current_location = [0, 0]
    @corners = [[0, 0]]
    @total_edge_lengths = 0
  end

  def add_edge(str)
    _, _, hexa = str.split(" ")
    
    direction = DIRECTIONS[hexa[7]]
    count = hexa[2..6].to_i(16)
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