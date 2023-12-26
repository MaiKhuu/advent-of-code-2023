require "../InputParser"

class ModuleConfiguration
  attr_reader :low_count, :high_count, :nodes_children, :nodes_type, :conjunction_connections, :queue, :last_received_from_connection
  
  def initialize
    # all types
    @nodes_children = {}
    @nodes_type = {}

    # flip flop
    @ff_state = {}
    
    # conjunction
    @last_received_from_connection = {}
    @conjunction_connections = {}

    # logistics
    @queue = []
    @high_count = 0 
    @low_count = 0
  end

  def add_module(str)
    words = str.scan(/\w+/)
    @nodes_children[words[0]] = words[1..-1]    

    if str.match?("broadcaster")
      @nodes_type["broadcaster"] = "broadcaster"  
    elsif str.match?("%")
      @nodes_type[words[0]] = "flip-flop"
      @ff_state[words[0]] = "off"
    elsif str.match("&")
      @nodes_type[words[0]] = "conjunction"
      @conjunction_connections[words[0]] = []
    end
  end

  def gather_conjunctions
    @nodes_children.each do |name, children|
      children.each do |child_name|
        if @nodes_type[child_name] == "conjunction"
          @conjunction_connections[child_name] << name 
        end
      end
    end

    @conjunction_connections.each do |node, connections|
      @last_received_from_connection[node] = {}
    end
  end

  def push_button
    @queue << ["button", "low", "broadcaster"]
    until @queue.empty?
      current = @queue.shift
      process_node(*current)
    end
  end

  def process_node(from_node, pulse_type, node_name)
    @low_count += 1 if pulse_type == "low" 
    @high_count += 1 if pulse_type == "high"
    
    if @nodes_type[node_name] == "broadcaster"
      @nodes_children[node_name].each do |child_name|
        @queue << [node_name, pulse_type, child_name]
      end

    elsif @nodes_type[node_name] == "flip-flop"
      return if pulse_type == "high"

      @ff_state[node_name] = @ff_state[node_name] == "on" ? "off" : "on"
      pulse_to_send = @ff_state[node_name] == "on" ? "high" : "low"

      @nodes_children[node_name].each do |child_name|
        @queue << [node_name, pulse_to_send, child_name]
      end

    elsif @nodes_type[node_name] == "conjunction"
      @last_received_from_connection[node_name][from_node] = pulse_type
      @conjunction_connections[node_name].each do |connecting_node|
        
        if @last_received_from_connection[node_name][connecting_node] != "high"
          @nodes_children[node_name].each do |child_name|
            @queue << [node_name, "high", child_name]
          end

          return

        end
      end

      @nodes_children[node_name].each do |child_name|
        @queue <<  [node_name, "low", child_name]
      end
    end
  end

  def part_1
    gather_conjunctions
    1000.times { push_button }
    @high_count * @low_count
  end
end

input = ModuleConfiguration.new
InputParser.into_array.each { |str| input.add_module(str) }
p input.part_1