#!/usr/bin/env ruby

input = $stdin.read.strip

# Part 1: What floor does Santa end up on?
floor = input.chars.sum { |char| char == '(' ? 1 : -1 }
puts "Part 1: #{floor}"

# Part 2: Position of first character that causes Santa to enter the basement (floor -1)
current_floor = 0
position = input.chars.each_with_index.find do |char, idx|
  current_floor += char == '(' ? 1 : -1
  current_floor == -1
end

puts "Part 2: #{position[1] + 1}" if position
