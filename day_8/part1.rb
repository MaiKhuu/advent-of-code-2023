require "../InputParser"

class Node
  attr_reader :name, :left_element, :right_element

  def initialize(str)
    @name = str[0..2]
    @left_element = str[7..9]
    @right_element = str[12..14]
  end

  def go_left
    @left_element
  end

  def go_right
    @right_element
  end
end

input = InputParser.into_array

directions = input.shift.chars
dir_length = directions.length

input.shift
nodes = {}
input.each { |str| nodes[str[0..2]] = Node.new(str) }

step = 0
current_node = "AAA"

while current_node != "ZZZ" do
  step += 1
  current_step = directions[(step - 1) % dir_length]
  current_node = current_step == "R" ? nodes[current_node].go_right : nodes[current_node].go_left
end

p step