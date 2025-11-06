total = 0
readlines.each do |line|
  sides = line.split('x').map &:to_i
  total += sides.sort.take(2).sum * 2 + sides.reduce(&:*)
end
puts total