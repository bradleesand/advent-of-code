# Track Santa's position and all houses visited
x = y = 0
houses = {[0, 0] => 1}
$<.read.bytes { |byte|
  # > (62) = east, < (60) = west, ^ (94) = north, v (118) = south
  x += byte == 62 ? 1 : byte == 60 ? -1 : 0
  y += byte == 94 ? 1 : byte == 118 ? -1 : 0
  houses[[x, y]] = 1
}
p houses.size
