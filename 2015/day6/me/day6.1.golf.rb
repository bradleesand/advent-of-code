g = Array.new(1000){Array.new(1000, false)}
$stdin.each do |l|
  /(?<cmd>on|off|toggle) (?<bx>\d+),(?<by>\d+) through (?<ex>\d+),(?<ey>\d+)/ =~ l
  bx,by,ex,ey=bx.to_i,by.to_i,ex.to_i,ey.to_i
  f = case cmd
  when 'on'
    ->(v){true}
  when 'off'
    ->(v){false}
  when 'toggle'
    ->(v){not v}
  end
  (bx..ex).each do |x|
    (by..ey).each do |y|
      g[x][y] = f.call(g[x][y])
    end
  end
end
puts g.flatten.count{|v|v}
