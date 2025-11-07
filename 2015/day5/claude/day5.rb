#!/usr/bin/env ruby

def nice_part1?(string)
  # At least 3 vowels
  return false if string.scan(/[aeiou]/).count < 3

  # At least one double letter
  return false unless string.match?(/(.)\1/)

  # Must not contain forbidden strings
  return false if string.match?(/ab|cd|pq|xy/)

  true
end

def nice_part2?(string)
  # Pair that appears twice without overlapping
  has_pair = false
  (0...string.length - 1).each do |i|
    pair = string[i..i+1]
    # Check if this pair appears again after position i+1
    has_pair = true if string[(i+2)..-1]&.include?(pair)
    break if has_pair
  end
  return false unless has_pair

  # Letter that repeats with exactly one letter between
  return false unless string.match?(/(.).\1/)

  true
end

strings = $stdin.readlines.map(&:strip)

part1 = strings.count { |s| nice_part1?(s) }
part2 = strings.count { |s| nice_part2?(s) }

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
