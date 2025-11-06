lines = readlines

# Part 1
total = 0
lines.each do |line|
  l, w, h = line.split('x').map(&:to_i)
  sides = [l*w, l*h, w*h]
  total += 2 * sides.reduce(&:+)
  total += sides.min
end
puts "Part 1: #{total}"

# Part 2
total = 0
lines.each do |line|
  sides = line.split('x').map(&:to_i)
  total += sides.sort.take(2).reduce(&:+) * 2
  total += sides.reduce(&:*)
end
puts "Part 2: #{total}"