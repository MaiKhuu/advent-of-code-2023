require "../InputParser"

class AllWorkFlows
  attr_reader :accepted_ranges
  def initialize(chunk)
    @workflows = {}
    chunk.split("\n").each do |line|
      name =  line.scan(/^\w+/)[0]
      rules = line.split("{")[1][0..-2]
      @workflows[name] = rules
    end
    @accepted_ranges = []
  end

  def split_range(curent_statements, wf_name)
    rules = @workflows[wf_name].split(",")
    result = {}

    rules.each do |r|
      if r.match?(/[<>]/)
        statement, next_location = r.split(":")
        result[next_location] = curent_statements + [statement]
        curent_statements += [statement + "FLIP"]
      else
        result[r] = curent_statements.clone
      end

      result.delete("R") if result["R"]
      @accepted_ranges << result.delete("A") if result["A"]
    end

    result.each { |next_location, statements| split_range(statements, next_location) }
  end

  def range_length(range_statements)
    result = {
      "x" => [0, 4001],
      "m" => [0, 4001],
      "a" => [0, 4001],
      "s" => [0, 4001],
    }

    range_statements.each do |rule|
      if rule.match("FLIP")
        if rule.match(">")
          result[rule[0]][1] = rule.scan(/\d+/).first.to_i + 1
        else
          result[rule[0]][0] = rule.scan(/\d+/).first.to_i - 1
        end
      else
        if rule.match(">")
          result[rule[0]][0] = rule.scan(/\d+/).first.to_i
        else
          result[rule[0]][1] = rule.scan(/\d+/).first.to_i
        end
      end
    end

    result.map { |_, arr| arr[1] - arr[0] - 1}.reduce(:*)
  end

  def part_2
    split_range([], "in")
    @accepted_ranges.map { |statments_arr| range_length(statments_arr)}.sum
  end
end

input = InputParser.into_chunks
workflows = AllWorkFlows.new(input[0])
p workflows.part_2