#!/usr/bin/env ruby
# Day 6 Part 2: Total brightness
# Brightness levels: turn on +1, turn off -1 (min 0), toggle +2

grid = Hash.new(0)

$<.each do |line|
  action, x1, y1, x2, y2 = line.match(/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/).captures
  (x1.to_i..x2.to_i).each do |x|
    (y1.to_i..y2.to_i).each do |y|
      grid[[x, y]] += action == "turn on" ? 1 : action == "toggle" ? 2 : -1
      grid[[x, y]] = 0 if grid[[x, y]] < 0
    end
  end
end

p grid.values.sum
