g = Array.new(1000){Array.new(1000, 0)}
$stdin.each do |l|
  /(?<c>on|off|toggle) (?<bx>\d+),(?<by>\d+) through (?<ex>\d+),(?<ey>\d+)/ =~ l
  bx,by,ex,ey=bx.to_i,by.to_i,ex.to_i,ey.to_i
  f = case c
  when 'on'
    ->(v){v+1}
  when 'off'
    ->(v){[0,v-1].max}
  when 'toggle'
    ->(v){v+2}
  end
  (bx..ex).each do |x|
    (by..ey).each do |y|
      g[x][y] = f.call(g[x][y])
    end
  end
end
puts g.flatten.inject :+
