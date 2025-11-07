#!/usr/bin/env ruby

require 'digest'

secret_key = $stdin.read.strip

# Part 1: Find lowest number that produces hash starting with 5 zeros
n = 1
loop do
  hash = Digest::MD5.hexdigest("#{secret_key}#{n}")
  break if hash.start_with?('00000')
  n += 1
end
part1 = n

# Part 2: Find lowest number that produces hash starting with 6 zeros
n = 1
loop do
  hash = Digest::MD5.hexdigest("#{secret_key}#{n}")
  break if hash.start_with?('000000')
  n += 1
end
part2 = n

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
