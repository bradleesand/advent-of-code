# Track floor and find when we first hit basement (-1)
floor = 0
$<.read.chars.each_with_index { |char, index|
  floor += char > ?( ? -1 : 1  # ) is -1, ( is +1
  (p index + 1; exit) if floor < 0
}
