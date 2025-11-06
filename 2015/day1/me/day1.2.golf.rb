s = 0
gets.bytes.each_with_index do |c, i|
  if c == 40
    s += 1
  else
    if s == 0
      puts i + 1
      exit
    end
    s -= 1
  end
end