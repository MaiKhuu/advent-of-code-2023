require "../InputParser"

class Sky
  attr_reader :same_x_velocity, :same_y_velocity, :same_z_velocity

  def initialize(arr)
    @hails = []
    arr.each { |s| add_hail(s) }
    tally_hails_with_same_velocity
  end
  
  def add_hail(str)
    @hails << str.scan(/[-\d]+/).map(&:to_i)
  end

  def tally_hails_with_same_velocity
    @same_x_velocity = [] 
    @same_y_velocity = []
    @same_z_velocity = []

    for i in 0..@hails.length - 2
      for j in i+1..@hails.length - 1
        hail_1 = @hails[i]
        hail_2 = @hails[j]

        @same_x_velocity << { "hails" => [hail_1, hail_2], "difference" => (hail_1[0] - hail_2[0]).abs,"velocity" => hail_1[3]} if hail_1[3] == hail_2[3]
        @same_y_velocity << { "hails" => [hail_1, hail_2], "difference" => (hail_1[1] - hail_2[1]).abs,"velocity" => hail_1[4]} if hail_1[4] == hail_2[4]
        @same_z_velocity << { "hails" => [hail_1, hail_2], "difference" => (hail_1[2] - hail_2[2]).abs,"velocity" => hail_1[5]} if hail_1[5] == hail_2[5]
      end
    end 
  end

  def get_valid_rock_velocity(difference, hail_velocity)
    result = []
    for i in 1..Math.sqrt(difference)
      if difference % i == 0
        result << i
        result << -1 * i
        if difference / i != i 
          result << difference / i 
          result << difference / i * -1
        end
      end
    end
    result.map { |f| f + hail_velocity }
  end

  def get_rock_velocity(hails_arr)
    result = nil
    hails_arr.each do |tuple|
      if result.nil? 
        result = get_valid_rock_velocity(tuple["difference"], tuple["velocity"])
      else
        result = result & get_valid_rock_velocity(tuple["difference"], tuple["velocity"])
        return result[0] if result.length == 1
      end
    end
    result
  end

  def get_rock_position(velocity_x, velocity_y, velocity_z)
    hail_1, hail_2 = @same_x_velocity[0]["hails"]
    distance_x = hail_1[0] - hail_2[0]
    hails_velocity = @same_x_velocity[0]["velocity"]
    
    steps = distance_x / (hail_1[3] - velocity_x)
    distance_y = steps * velocity_y
    
    collision_time = (hail_2[1] - hail_1[1] - distance_y + steps * hail_2[4]) / (hail_1[4] - hail_2[4])

    position_at_collision_time = [
      hail_1[0] + collision_time * hail_1[3],
      hail_1[1] + collision_time * hail_1[4],
      hail_1[2] + collision_time * hail_1[5],
    ]

    possition_at_start = [
      position_at_collision_time[0] - collision_time * velocity_x, 
      position_at_collision_time[1] - collision_time * velocity_y, 
      position_at_collision_time[2] - collision_time * velocity_z, 
    ]

    possition_at_start
  end

  def part_2
    rock_velocity = [@same_x_velocity, @same_y_velocity, @same_z_velocity].map do |hails_arr|
      get_rock_velocity(hails_arr)
    end

    rock_position = get_rock_position(*rock_velocity)
    rock_position.reduce(&:+)
  ends
end

sky = Sky.new(InputParser.into_array)
p sky.part_2