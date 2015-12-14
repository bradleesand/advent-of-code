total = 0

$stdin.each_line do |line|
  sides = line.split('x').map(&:to_i)
  total += sides.sort.take(2).reduce(&:+) * 2
  total += sides.reduce(&:*)
end
puts total
