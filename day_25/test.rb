# Read input from file
lines = File.readlines('input.txt').map(&:chomp)

# Define a simple Graph class
class SimpleGraph
  attr_accessor :edges

  def initialize
    @edges = Set.new
  end

  def add_edge(node1, node2)
    @edges.add([node1, node2])
    @edges.add([node2, node1])
  end

  def remove_edge(node1, node2)
    @edges.delete([node1, node2])
    @edges.delete([node2, node1])
  end

  def node_connected_component(node)
    connected_nodes = Set.new
    @edges.each do |edge|
      connected_nodes.add(edge[1]) if node == edge[0]
      connected_nodes.add(edge[0]) if node == edge[1]
    end
    connected_nodes
  end
end

# Create a simple graph and populate it with edges
graph = SimpleGraph.new
lines.each do |line|
  row = line.split(':').map(&:strip)
  targets = row[1].split().map(&:strip)
  targets.each { |target| graph.add_edge(row[0], target) }
end

# Calculate costs
costs = []
graph.edges.dup.each do |edge|
  graph.remove_edge(*edge)
  shortest_path_length = graph.node_connected_component(edge[0]).size + graph.node_connected_component(edge[1]).size
  costs << [edge, shortest_path_length]
  graph.add_edge(*edge)
end

# Sort costs and remove top 3 edges
costs.sort_by! { |x| x[1] }.reverse!.first(3).each { |edge| graph.remove_edge(*edge[0]) }

# Print results
puts "removing #{costs[0][0]} #{costs[1][0]} #{costs[2][0]}"
puts "part1 #{graph.node_connected_component(costs[0][0][0]).size * graph.node_connected_component(costs[0][0][1]).size}"
