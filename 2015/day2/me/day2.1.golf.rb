total = 0
readlines.each { |line|
  l, w, h = line.split('x').map &:to_i
  sides = [l*w, l*h, w*h]
  total += 2 * sides.sum + sides.min
}
puts total