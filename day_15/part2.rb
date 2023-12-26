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

class LensBoxes
  def initialize
    @boxes = Array.new(256).map { [] }
  end

  def run(operation_str)
    if operation_str.match("=")
      run_equal_sign(operation_str)
    elsif operation_str.match("-")
      run_dash_sign(operation_str)
    end
  end

  def run_equal_sign(operation_str)
    label, focal_length = operation_str.split("=")
    box_num = HashAlgorithm.run(label)
    to_replace = @boxes[box_num].index { |box| box[label] }
    if to_replace
      @boxes[box_num][to_replace][label] = focal_length
    else 
      @boxes[box_num] << { label => focal_length }
    end
  end

  def run_dash_sign(operation_str)
    label = operation_str[0..-2]
    box_num = HashAlgorithm.run(label)
    to_delete = @boxes[box_num].index { |box| box[label] }
    @boxes[box_num].delete_at(to_delete) if to_delete
  end

  def focusing_power
    result = 0
    @boxes.each.with_index do |box, i|
      box.each.with_index do |lens, ii|
        lens.each { |_, v| result += (i + 1) * (ii + 1) * (v.to_i)}
      end
    end
    result
  end

  def show
    @boxes.each.with_index do |box, i|
      unless box.empty?
        result = "Box #{i}:"
        box.each do |lens|
          lens.each { |k, v| result += " [#{k} #{v}] "}
        end
        puts result
      end
    end
  end
end

lens_boxes = LensBoxes.new
input = InputParser.into_single_string.split(",")
input.each { |str| lens_boxes.run(str) }
p lens_boxes.focusing_power
