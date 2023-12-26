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

def arrived?(node_arr)
  node_arr.all? { |str| str[2] == "Z" }
end

input = InputParser.into_array

directions = input.shift.chars
dir_length = directions.length

input.shift
nodes = {}

current_nodes = []
steps = []

input.each do |str| 
  node_name = str[0..2]
  nodes[node_name] = Node.new(str) 
  current_nodes << node_name if node_name[2] == "A"
end

current_nodes.each do |current_node|
  step = 0

  while current_node[2] != "Z" do
    step += 1
    current_step = directions[(step - 1) % dir_length]
    current_node = current_step == "R" ? nodes[current_node].go_right : nodes[current_node].go_left
  end

  steps << step
end

p steps.reduce { |a, b| a.lcm(b) }