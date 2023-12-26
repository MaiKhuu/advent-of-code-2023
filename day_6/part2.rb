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
time = input[0].scan(/\d+/).reduce(&:+).to_i
distance = input[1].scan(/\d+/).reduce(&:+).to_i

p Race.new(time, distance).hold_time_options
