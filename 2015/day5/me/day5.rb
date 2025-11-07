input = readlines
# Part 1
part1 = input.count{|l|
  c=l.chars
  l.count('aeiou')>2 && c.zip(c.drop(1)).any?{|x|x.uniq.size<2} && l[/ab|cd|pq|xy/].nil?
}
puts "Part 1: #{part1}"

# Part 2
part2 = input.count{|l|
  c=l.chars
  c.zip(c.drop(2)).any?{|x|x.uniq.size<2} &&
    (1...l.size).any?{|i| l.slice((i+1)..-1).include? l.slice(i-1,2) }
}
puts "Part 2: #{part2}"