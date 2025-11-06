chars = gets.chars

# Part 1
x = 0, 0
visited = [x] + chars.map do |c|
  x = case c
  when '^'
    [x[0], x[1]-1]
  when '>'
    [x[0]+1, x[1]]
  when 'v'
    [x[0], x[1]+1]
  when '<'
    [x[0]-1, x[1]]
  end
end
puts "Part 1: #{visited.uniq.size}"


# Part 2
x = [[0,0],[0,0]]
i = 0
visited = [x[i]]+chars.map do |c|
  i=(i+1) % 2
  y = x[i]
  x[i] = case c
  when '^'
    [y[0], y[1]-1]
  when '>'
    [y[0]+1, y[1]]
  when 'v'
    [y[0], y[1]+1]
  when '<'
    [y[0]-1, y[1]]
  end
end

puts "Part 2: #{visited.uniq.size}"
