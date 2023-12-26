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

  def look_down(destination_num)
    @ranges.each do |r|
      return destination_num - r["destination"] + r["source"] if 
      (r["destination"]..r["destination"] + r["range"] - 1).cover?(destination_num)
    end
    return destination_num
  end
end

class SeedRanges
  def initialize(str)
    @ranges = str.scan(/\d+ \d+/)
                 .map { |s| s.split(" ")
                             .map(&:to_i) }
                 .map{ |s, r| {"start" => s, "end" => s + r} }
  end

  def exists_in_range(num)
    @ranges.any? { |r| (r["start"]..r["end"]).cover?(num) }
  end
end

input_string = InputParser.into_single_string
                          .split("\n\n")

seed_ranges = SeedRanges.new(input_string.shift)

ratios = []
input_string.each { |str| ratios << Ratio.new(str) }
ratios.reverse!

counter = 1
loop do 
  current = counter
  ratios.each { |r| current = r.look_down(current) }
  if seed_ranges.exists_in_range(current) 
    p counter
    return
  end
  counter += 1
end
