$instructions = {}

def parse cmd
  /^((?<val>\d+)$|(?<var>[[:lower:]]+)|((?<lhs>.+?) )?(?<op>NOT|OR|AND|LSHIFT|RSHIFT) (?<rhs>.+))$/ =~ cmd.to_s
  #puts "parse(#{cmd})"
  #puts "val: #{val.inspect}"
  #puts "var: #{var.inspect}"
  #puts "lhs: #{lhs.inspect}"
  #puts "op: #{op.inspect}"
  #puts "rhs: #{rhs.inspect}"
  case op
  when nil
    if val
      val.to_i
    else
      evaluate(var)
    end
  when 'NOT'
    ~ parse(rhs)
  when 'OR'
    parse(lhs) | parse(rhs)
  when 'AND'
    parse(lhs) & parse(rhs)
  when 'LSHIFT'
    parse(lhs) << parse(rhs)
  when 'RSHIFT'
    parse(lhs) >> parse(rhs)
  end
end

def evaluate key
  #puts "evalutate(#{key})"
  $instructions[key] = parse($instructions[key])
end

$stdin.each do |line|
  /^(?<lhs>.+?) -> (?<rhs>.+?)$/ =~ line
  $instructions[rhs] = lhs
end

bak = $instructions.dup
x = evaluate ARGV[0]

puts "#{ARGV[0]}: #{x}"

$instructions = bak
$instructions[ARGV[1]] = x.to_s
puts "#{ARGV[0]}: #{evaluate ARGV[0]}"
