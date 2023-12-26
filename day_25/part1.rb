require "../InputParser"

class Machine
  attr_reader :graph
  def initialize(arr)
    @graph = {}
    make_graph(arr)
  end

  def make_graph(arr)
    arr.each do |str|
      components = str.scan(/\w+/)
      @graph[components[0]] = @graph[components[0]] || []
      components[1..-1].each do |child|
        @graph[components[0]] << child
        @graph[child] = (@graph[child] || []) << components[0]
      end
    end
  end

  def build_cluster
    @cluster = Set.new([@graph.first[0]])
    loose_ends = Set.new(@graph.first[1])
    puts @graph
    puts
    
    until loose_ends.length == 3
      p loose_ends
      gets
      @cluster.merge(loose_ends)
      new_loose_ends = Set.new()
      loose_ends.each do |child|
        @graph[child].each do |c|
          new_loose_ends << c if !@cluster.include?(c)
        end
      end
      loose_ends = new_loose_ends
    end
  end

  def calc_result
    cluster1_size = @cluster.length
    cluster2_size = @graph.length - cluster1_size - 3
    cluster1_size * cluster2_size
  end

  def part_1
    build_cluster
    p @cluster.length
    # calc_result
  end
end

input = Machine.new(InputParser.into_array)
p input.part_1