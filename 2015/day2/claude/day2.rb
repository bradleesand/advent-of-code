#!/usr/bin/env ruby

input = $stdin.readlines.map(&:strip).reject(&:empty?)

# Parse dimensions
presents = input.map { |line| line.split('x').map(&:to_i) }

# Part 1: Calculate wrapping paper needed
total_paper = presents.sum do |l, w, h|
  surface_area = 2*l*w + 2*w*h + 2*h*l
  slack = [l*w, w*h, h*l].min
  surface_area + slack
end

puts "Part 1: #{total_paper}"

# Part 2: Calculate ribbon needed
total_ribbon = presents.sum do |l, w, h|
  # Smallest perimeter (wrap around smallest face)
  perimeter = 2 * [l+w, w+h, h+l].min
  # Bow (volume)
  bow = l * w * h
  perimeter + bow
end

puts "Part 2: #{total_ribbon}"
