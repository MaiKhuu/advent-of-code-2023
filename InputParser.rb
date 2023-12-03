INPUT_PATH = 'input.txt'

class InputParser
  def self.into_array
    File.readlines(INPUT_PATH)
        .map(&:chomp)
  end

  def self.into_chars_array
    File.readlines(INPUT_PATH)
        .map(&:chomp)
        .map(&:chars)
  end
end