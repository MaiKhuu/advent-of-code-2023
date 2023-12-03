require "../InputParser"

DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1],
              [0, -1], [0, 1],
              [1, -1], [1, 0], [1, 1]]

class Engine
  def initialize(arr)
    @arr = arr
    @row_count = arr.length
    @col_count = arr.first.length
  end

  def parts_sum
    sum = 0
    for i in (0..@col_count - 1)
      for j in (0..@row_count - 1)
        sum += grab_touching_nums_sum(i, j) if is_symbol?(i, j)
      end
    end
    sum
  end
  
  def grab_touching_nums_sum(row, col)
    sum = 0
    DIRECTIONS.each do |dir|
      r = row + dir.first
      c = col + dir.last
      sum += grab_num(r, c) if inbound?(r,c) && is_num?(r,c)
    end
    sum
  end

  def grab_num(row, col)
    result = pop_num(row, col)
    
    temp_col = col - 1
    while inbound?(row, temp_col) && is_num?(row, temp_col) 
      result = pop_num(row, temp_col) + result
      temp_col -= 1
    end

    temp_col = col + 1
    while inbound?(row, temp_col) && is_num?(row, temp_col) 
      result = result + pop_num(row, temp_col)
      temp_col += 1
    end

    result.to_i
  end

  def pop_num(row, col)
    num = @arr[row][col]
    @arr[row][col] = '.'
    num
  end

  def inbound?(row, col)
    row >=0 && row <= @row_count - 1 &&
    col >= 0 && col <= @col_count - 1
  end

  def is_symbol?(row, col)
    !@arr[row][col].match(/[0-9]|\./)
  end
  
  def is_num?(row, col)
    @arr[row][col].match(/[0-9]/)
  end
end

p Engine.new(InputParser.into_chars_array).parts_sum