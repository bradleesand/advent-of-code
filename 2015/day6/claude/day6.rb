#!/usr/bin/env ruby

instructions = $stdin.readlines.map(&:strip)

# Parse instructions
parsed = instructions.map do |line|
  if line =~ /(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/
    {
      action: $1,
      x1: $2.to_i,
      y1: $3.to_i,
      x2: $4.to_i,
      y2: $5.to_i
    }
  end
end

# Part 1: Binary on/off lights
grid1 = Hash.new(false)

parsed.each do |inst|
  (inst[:x1]..inst[:x2]).each do |x|
    (inst[:y1]..inst[:y2]).each do |y|
      case inst[:action]
      when "turn on"
        grid1[[x, y]] = true
      when "turn off"
        grid1[[x, y]] = false
      when "toggle"
        grid1[[x, y]] = !grid1[[x, y]]
      end
    end
  end
end

part1 = grid1.values.count(true)

# Part 2: Brightness levels
grid2 = Hash.new(0)

parsed.each do |inst|
  (inst[:x1]..inst[:x2]).each do |x|
    (inst[:y1]..inst[:y2]).each do |y|
      case inst[:action]
      when "turn on"
        grid2[[x, y]] += 1
      when "turn off"
        grid2[[x, y]] = [grid2[[x, y]] - 1, 0].max
      when "toggle"
        grid2[[x, y]] += 2
      end
    end
  end
end

part2 = grid2.values.sum

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
