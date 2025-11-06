level = 0
position = 0
first_basement_position = nil
$stdin.each_char do |c|
  position += 1
  case c
  when '('
    level += 1
  when ')'
    level -= 1
  else
    $stderr.puts "Error: Unknown character: #{c}"
  end
  first_basement_position = position if level == -1 && first_basement_position.nil?
end
puts "Part 1: #{level}"
puts "Part 2: #{first_basement_position}"