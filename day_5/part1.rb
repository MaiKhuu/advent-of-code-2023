require "../InputParser"

class Ratio
  def initialize(str)
    @destination, _, @source, _ = str.scan(/[a-z]+/)
    @ranges = str.split("\n")[1..-1]
                 .map { |s| s.split(" ") }
                 .map { |arr| arr.map(&:to_i) }
                 .map { |arr| {"source" => arr[1], 
                               "destination" => arr[0], 
                               "range" => arr[2]} }
  end

  def look_up(source_num)
    @ranges.each do |r| 
      return r["destination"] + source_num - r["source"] if 
      (r["source"]..r["source"] + r["range"] - 1).cover?(source_num)
    end
    return source_num
  end
end

input_string = InputParser.into_single_string
                          .split("\n\n")
seeds = input_string.shift
                    .scan(/\d+/)
                    .map(&:to_i)

input_string.each do |str|
  current_ratio = Ratio.new(str)
  seeds = seeds.map do |seed|
    current_ratio.look_up(seed)
  end
end

p seeds.min