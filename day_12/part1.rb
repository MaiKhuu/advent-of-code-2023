require "../InputParser"

class ConditionRecord
  attr_reader :springs, :clusters
  def initialize(str)
    @springs, @clusters = str.split(" ")
    @springs = "." + @springs + "."
    @clusters = @clusters.split(",").map(&:to_i)
  end

  def get_part1
    get_possibilities(@springs, @clusters)
  end

  def get_possibilities(str, cluster_arr)
    return str.match('#') ? 0 : 1 if cluster_arr.empty?
    
    current_cluster = cluster_arr[0]
    left_over_clusters = cluster_arr[1..-1]

    candidates = []
    (str.length - 1 + 1).times do |i|
      regex = /^[.?]{#{i+1}}[#?]{#{current_cluster}}[.?]/
      if str.match?(regex) 
        candidates << "." + str[i + 2 + current_cluster..-1]
      end
    end

    return 0 if candidates.empty?
    return candidates.map{ |c| get_possibilities(c, left_over_clusters) }.sum
  end
end

input = InputParser.into_array.map { |s| ConditionRecord.new(s) }
p input.map(&:get_part1).sum