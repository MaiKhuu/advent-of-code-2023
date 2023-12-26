require "../InputParser"

class HashAlgorithm
  def self.run(str)
    result = 0
    str.chars.each do |c|
      result = ((result + c.ord) * 17) % 256
    end
    result
  end
end

p InputParser.into_single_string
             .split(",")
             .map { |str| HashAlgorithm.run(str) }
             .sum