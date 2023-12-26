require "../InputParser"

def first_digit(str)
  str.scan(/[0-9]/).first.to_i
end

def get_num(str)
  first_digit(str) * 10 + 
  first_digit(str.reverse)
end

p InputParser.into_array
             .map { |str| get_num(str) }
             .sum