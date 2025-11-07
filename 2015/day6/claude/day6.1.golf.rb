#!/usr/bin/env ruby
# Day 6 Part 1: Count lights that are on
# Binary on/off grid with turn on, turn off, toggle commands

grid = Hash.new(false)

$<.each do |line|
  action, x1, y1, x2, y2 = line.match(/(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/).captures
  (x1.to_i..x2.to_i).each do |x|
    (y1.to_i..y2.to_i).each do |y|
      grid[[x, y]] = action == "turn on" ? true : action == "turn off" ? false : !grid[[x, y]]
    end
  end
end

p grid.values.count(true)
