x, y = 0, 0

puts ([[x, y]] + gets.bytes.map do |c|
  x, y = case c
  when 94 # ^
    [x, y-1]
  when 62 # >
    [x+1, y]
  when 118 # v
    [x, y+1]
  when 60 # <
    [x-1, y]
  end
end).uniq.size
