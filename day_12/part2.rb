require "../InputParser"

class ConditionRecord
  attr_reader :string, :clusters, :grid, :substrings

  def initialize(str)
    @string, @clusters = str.split(" ")
    
    @string = "." + @string + "?" + @string + "?" + @string + "?" + @string + "?" + @string

    @substrings = @string.length.times.map { |i| @string[0..i] }
    
    @clusters = @clusters.split(",").map(&:to_i)
    @clusters = [0]  +  @clusters + @clusters + @clusters + @clusters + @clusters 

    @grid = initial_grid
  end

  def initial_grid
    result = {}
    
    result[""] = {}
    @clusters.length.times { |i| result[""][i] = 0 }
    result[""][0] = 1

    @substrings.each do |sub_string|
      result[sub_string] = {}
      result[sub_string][0] = sub_string.match?("#") ? 0 : 1
    end

    result
  end

  def tabulate
    for cluster_idx in (1..@clusters.length-1) 
      cluster_number = @clusters[cluster_idx]
      @substrings.each do |sub_string|
        if sub_string.length <= cluster_number
          @grid[sub_string][cluster_idx] = 0
        elsif sub_string[-1] == "."
          previous_sub_string = sub_string.length >= 2 ? sub_string[0..-2] : ""
          @grid[sub_string][cluster_idx] = @grid[previous_sub_string][cluster_idx]
        else
          total = 0;
          for ending_dots_count in 0..substrings.length - 1 - (cluster_number + 1)
            regex = /[.?][#?]{#{cluster_number}}[.?]{#{ending_dots_count}}$/
            if sub_string.match?(regex)
              regex_length = 1 + cluster_number + ending_dots_count
              left_over_string = regex_length >= sub_string.length ? "" :sub_string[0..sub_string.length - regex_length - 1] 
              total += 1 * @grid[left_over_string][cluster_idx - 1]
            end
          end
          @grid[sub_string][cluster_idx] = total
        end
      end
    end
  end

  def answer
    tabulate
    @grid[@string][@clusters.length - 1]
  end
end

input = InputParser.into_array.map { |s| ConditionRecord.new(s) }
p input.map{ |i| i.answer }.sum