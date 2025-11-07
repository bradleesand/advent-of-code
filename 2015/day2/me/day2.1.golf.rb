puts readlines.sum { |line|
  l, w, h = line.split('x').map &:to_i
  sides = [l*w, l*h, w*h]
  2 * sides.sum + sides.min
}