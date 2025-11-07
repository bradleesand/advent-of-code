require 'digest'

key=$stdin.read

# Part 1
i = -1
i += 1 until Digest::MD5.hexdigest("#{key}#{i}")[/^0{5}/]
puts "Part 1: #{i}"

# Part 2
i = -1
i += 1 until Digest::MD5.hexdigest("#{key}#{i}")[/^0{6}/]
puts "Part 2: #{i}"