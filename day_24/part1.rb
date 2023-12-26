require "../InputParser"

TEST_RANGE_MIN = 200000000000000
TEST_RANGE_MAX = 400000000000000

class Hail
  attr_reader :a, :b, :x0, :y0, :delta_x, :delta_y
  def initialize(str)
    @x0, @y0, _, @delta_x, @delta_y, _ = str.scan(/[-0-9]+/).map(&:to_i)
    @a = @delta_y * 1.0 / @delta_x
    @b = @y0 - @a * @x0
  end

  def intersect_in_range?(other_hail)
    return false if @a == other_hail.a 

    intersect_x = (other_hail.b - @b) / (@a - other_hail.a)
    return false unless intersect_x >= TEST_RANGE_MIN && intersect_x <= TEST_RANGE_MAX

    intersect_y = @a * intersect_x + b
    return false unless intersect_y >= TEST_RANGE_MIN && intersect_y <= TEST_RANGE_MAX

    my_time = (intersect_y - @y0) / @delta_y
    return false if my_time < 0

    their_time = (intersect_y - other_hail.y0) / other_hail.delta_y
    return false if their_time < 0

    true
  end
end

input = InputParser.into_array
hails = input.map { |str| Hail.new(str) }

# part1
count = 0
for h1 in hails
  for h2 in hails
    count += 1 if h1 != h2 && h1.intersect_in_range?(h2)
  end
end
p count / 2