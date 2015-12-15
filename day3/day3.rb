x=0,0
p ([x]+$stdin.each_char.map{|c|x=case c
when '^'
[x[0],x[1]-1]
when '>'
[x[0]+1,x[1]]
when 'v'
[x[0],x[1]+1]
when '<'
[x[0]-1,x[1]]
end
}).uniq.size
