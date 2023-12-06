require "../InputParser"

class Race
  def initialize(time, distance)
    @time = time
    @record_distance = distance
  end

  def quadratic_solve
    delta = @time**2 - 4 * @record_distance
    sqrt_delta = Math.sqrt(delta)
    range_start = (@time - sqrt_delta) / 2.0
    range_end = (@time + sqrt_delta) / 2.0
    [range_start, range_end]
  end

  def hold_time_options
    range_start, range_end = quadratic_solve
    range_start +=1 if range_start.to_i == range_start
    range_end -= 1 if range_end.to_i == range_end
    ((range_start).ceil..(range_end).floor).to_a.length
  end
end

input = InputParser.into_array
times = input[0].scan(/\d+/).map(&:to_i)
distances = input[1].scan(/\d+/).map(&:to_i)

records = times.map.with_index do |time, i|
  Race.new(time, distances[i])
end

p records.map{ |r| r.hold_time_options }
         .reduce(&:*)