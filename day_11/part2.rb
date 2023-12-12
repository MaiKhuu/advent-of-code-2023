require "../InputParser"

class Image
  attr_reader :map, :galaxies, :empty_columns, :empty_rows

  def initialize(arr)
    taken_columns = []
    @empty_rows = []
    @galaxies = []
    @map = []
    arr.each.with_index do |row, i|
      @empty_rows << i if row.all? { |c| c == "." }

      row.each.with_index do |c, j| 
        if c == "#" 
          taken_columns << j 
          @galaxies << [i, j]
        end
      end
  
      @map << row
    end

    @height = @map.length
    @width = @map.first.length
    @empty_columns = (0..@height - 1).to_a - taken_columns

    expand_universe
  end

  def expand_universe
    expanded_galaxies = []
    @galaxies.each do |i, j|
      expanded_galaxies << [i + 999999 * @empty_rows.count {|r| r < i }, j + 999999 * @empty_columns.count { |c| c < j }]
    end
    @galaxies = expanded_galaxies
  end

  def get_distance(a, b)
    (a.first - b.first).abs + (a.last - b.last).abs
  end

  def get_distances_sum
    result = 0
    for i in 0..@galaxies.length - 2 do 
      for j in i+1..@galaxies.length - 1 do
        result += get_distance(@galaxies[i], @galaxies[j]) 
      end
    end
    result
  end
end

my_image = Image.new(InputParser.into_chars_array)
p my_image.get_distances_sum
# p my_image.galaxies, my_image.empty_columns, my_image.empty_rows