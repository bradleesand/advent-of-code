x=[[0,0],[0,0]]
i=0
p ([x[i]]+$stdin.each_char.map{|c|
  i=(i+1)%2
  y = x[i]
  x[i]=case c
    when '^'
      [y[0],y[1]-1]
    when '>'
      [y[0]+1,y[1]]
    when 'v'
      [y[0],y[1]+1]
    when '<'
      [y[0]-1,y[1]]
    end
}).uniq.size
