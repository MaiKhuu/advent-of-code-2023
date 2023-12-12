require "../InputParser"

class Image
  attr_reader :map, :galaxies

  def initialize(arr)
    @map = expand_universe(arr)
    @height = @map.length
    @width = @map.first.length
    @galaxies = get_galaxy_locations
  end

  def expand_universe(arr)
    result = [] 
    taken_columns = []
    
    while arr.length != 0
      new_row = arr.shift
      new_row.each.with_index { |c, i| taken_columns << i if c == "#" }
      result << new_row
      result << new_row.clone if new_row.all?{ |c| c == "." }
    end
    
    columns_to_add = (0..result.length - 1).to_a - taken_columns
    result = add_columns(result, columns_to_add)
  end

  def add_columns(arr, columns_to_add)
    result = []
    arr.each do |row|
      result << []
      row.each.with_index do |c, i|
        result.last << "." if columns_to_add.include?(i)
        result.last << c  
      end
    end
    result
  end

  def get_galaxy_locations
    result = []
    @map.each.with_index do |row, i|
      row.each.with_index do |c, j|
        result << [i, j] if c == "#"
      end
    end
    result
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