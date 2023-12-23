require "../InputParser"



class Grid
  attr_reader :supports, :supported_by, :bricks
  def initialize(input)
    @bricks = input.map { |s| s.scan(/\d+/).map(&:to_i) }
    @supports = Array.new(input.length).map{ [] }
    @supported_by = Array.new(input.length).map{ [] }
  end

  def sort_bricks
    @bricks.sort_by!{ |_, _, z, _, _, _| z}
  end

  def overlap(brick1, brick2)
    [brick1[0], brick2[0]].max <= [brick1[3], brick2[3]].min &&
    [brick1[1], brick2[1]].max <= [brick1[4], brick2[4]].min
  end

  def calibration
    @bricks.each.with_index do |brick, idx|
      if idx > 0
        z_max = 1
        @bricks[0..idx-1].each do |b|
          z_max = [z_max, b[5] + 1].max if overlap(brick, b)
        end
        brick[5] -= brick[2] - z_max
        brick[2] = z_max
      end
    end
  end

  def tally
    @bricks.each.with_index do |brick, idx|
      if idx > 0
        @bricks[0..idx-1].each.with_index do |b, i|
          if overlap(brick, b) && brick[2] == b[5] + 1
            @supports[i] << idx
            @supported_by[idx] << i
          end
        end
      end
    end
  end

  def count_falling_bricks(brick_idx)
    fallen_bricks = Set.new()
    fallen_bricks << brick_idx
    queue = @supports[brick_idx].clone
    until queue.empty?
      current = queue.shift
      @supports[current].each { |b_idx| queue << b_idx }
      fallen_bricks << current if @supported_by[current].all? { |b_idx| fallen_bricks.include?(b_idx) }
    end
    fallen_bricks.length - 1
  end

  def count_total_falling_bricks
    @bricks.length.times.map{ |i| count_falling_bricks(i)}.sum
  end

  def part_2
    sort_bricks
    calibration
    sort_bricks
    tally
    count_total_falling_bricks
  end
end

grid = Grid.new(InputParser.into_array)
p grid.part_2


