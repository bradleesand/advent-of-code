level = 0
position = 0
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
  puts position if level == -1
end
puts level
