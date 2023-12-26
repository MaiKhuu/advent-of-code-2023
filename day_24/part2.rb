require "../InputParser"

TEST_RANGE_MIN = 200000000000000
TEST_RANGE_MAX = 400000000000000

class Sky
  def initialize(arr)
    @hails = []
    arr.each { |s| add_hail(s) }
  end

  def add_hail(str)
    # x, y, z, vx, vy, vz = str.scan(/[-\d]+/).map(:to_i)
    @hails << str.scan(/[-\d]+/).map(:to_i)
  end
end

sky = Sky.new(InputParser.into_array)
puts "hey"
p sky
# hails = input.map { |str| Hail.new(str) }