total = 0
$stdin.each_line do |line|
  l, w, h = line.split('x').map(&:to_i)
  sides = [l*w, l*h, w*h]
  total += 2 * sides.reduce(&:+)
  total += sides.min
end
puts total
