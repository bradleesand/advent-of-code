#!/usr/bin/env ruby

input = $stdin.read.strip

# Part 1: Track houses visited by Santa
def count_houses(directions)
  visited = Set.new
  x, y = 0, 0
  visited.add([x, y])

  directions.each_char do |dir|
    case dir
    when '^' then y += 1
    when 'v' then y -= 1
    when '>' then x += 1
    when '<' then x -= 1
    end
    visited.add([x, y])
  end

  visited.size
end

puts "Part 1: #{count_houses(input)}"

# Part 2: Santa and Robo-Santa take turns
def count_houses_with_robot(directions)
  visited = Set.new
  santa_x, santa_y = 0, 0
  robot_x, robot_y = 0, 0
  visited.add([0, 0])

  directions.each_char.with_index do |dir, idx|
    if idx.even?
      # Santa's turn
      case dir
      when '^' then santa_y += 1
      when 'v' then santa_y -= 1
      when '>' then santa_x += 1
      when '<' then santa_x -= 1
      end
      visited.add([santa_x, santa_y])
    else
      # Robo-Santa's turn
      case dir
      when '^' then robot_y += 1
      when 'v' then robot_y -= 1
      when '>' then robot_x += 1
      when '<' then robot_x -= 1
      end
      visited.add([robot_x, robot_y])
    end
  end

  visited.size
end

puts "Part 2: #{count_houses_with_robot(input)}"
