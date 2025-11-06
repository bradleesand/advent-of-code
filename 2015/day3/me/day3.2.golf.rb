# ^ = 94, > = 62, v = 118, < = 60

last_pos = [0,0], [0,0]
puts (last_pos + gets.bytes.map.with_index { |c, i|
  x, y = last_pos[ i % 2 ]

  last_pos[ i % 2 ] = case c
  when 94 # ^
    [x, y-1]
  when 62 # >
    [x+1, y]
  when 118 # v
    [x, y+1]
  when 60 # <
    [x-1, y]
  end
}).uniq.size
