require "../InputParser"

DIGIT_SPELLING = { 
  "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5,
  "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9,
  "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5,
  "6" => 6, "7" => 7, "8" => 8, "9" => 9,
}

REGEX = /[0-9]|one|two|three|four|five|six|seven|eight|nine/
REVERSED_REGEX = /[0-9]|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno/

def first_digit(str)
  DIGIT_SPELLING[str.scan(REGEX).first]
end

def last_digit(str)
  DIGIT_SPELLING[str.reverse.scan(REVERSED_REGEX).first.reverse]
end

def get_num(str)
  first_digit(str) * 10 + last_digit(str)
end

p InputParser.into_array
             .map { |str| get_num(str) }
             .sum