require "../InputParser"

class Part
  def initialize(str)
    @x, @m, @a, @s = str.scan(/\d+/).map(&:to_i)
  end

  def [](attribute)
    case attribute
    when "x"
      return @x
    when "m"
      return @m
    when "a"
      return @a
    when "s"
      return @s
    end
  end

  def sum
    @x + @m + @a + @s
  end
end

class WorkFlow
  def initialize(str)
    @rules = {}
    str.scan(/{.*}/)[0]
       .gsub(/[{}]/,"")
       .split(",")
       .map { |s| s.split(":") }
       .each { |pair| pair.length == 1 ? @rules[""] = pair[0] : @rules[pair[0]] = pair[1]}
  end

  def rule_applied?(rule, part)
    return true if rule == ""
    first, second = rule.scan(/\w+/)
    comparision = rule.scan(/[<>]/)[0]
    if comparision == ">"
      return part[first] > second.to_i
    else 
      return part[first] < second.to_i
    end
  end

  def next_destination(part)
    @rules.each do |rule, destination|
      return destination if rule_applied?(rule, part)
    end
  end
end

class AllWorkFlows
  def initialize(block)
    @workflows = {}
    block.split("\n").each do |line| 
      wf = WorkFlow.new(line) 
      wf_name = line.scan(/^\w+/)[0]
      @workflows[wf_name] = wf
    end
  end

  def accepted?(part)
    current_location = "in"
    loop do
      current_location = @workflows[current_location].next_destination(part)
      return true if current_location == "A"
      return false if current_location == "R"
    end
  end
end

input = InputParser.into_chunks
workflows = AllWorkFlows.new(input[0])
parts = input[1].split("\n").map{ |line| Part.new(line) }

p parts.filter { |p| workflows.accepted?(p) }.map(&:sum).sum
