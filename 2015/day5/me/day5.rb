puts $stdin.count{|l|
  c=l.chars
  l.count('aeiou')>2 && c.zip(c.drop(1)).any?{|x|x.uniq.size<2} && l[/ab|cd|pq|xy/].nil?
}
