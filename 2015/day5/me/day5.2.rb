puts $stdin.count{|l|
  c=l.chars
  c.zip(c.drop(2)).any?{|x|x.uniq.size<2} &&
    (1...l.size).any?{|i| l.slice((i+1)..-1).include? l.slice(i-1,2) }
}
