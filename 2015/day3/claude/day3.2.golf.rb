# Track both Santa and Robo-Santa positions
santa_x = santa_y = robo_x = robo_y = 0
houses = {[0, 0] => 1}
$<.read.bytes.each_slice(2) { |santa_move, robo_move|
  # Santa's move (even indices)
  santa_x += santa_move == 62 ? 1 : santa_move == 60 ? -1 : 0
  santa_y += santa_move == 94 ? 1 : santa_move == 118 ? -1 : 0
  houses[[santa_x, santa_y]] = 1

  # Robo-Santa's move (odd indices) - check if exists
  robo_x += robo_move == 62 ? 1 : robo_move == 60 ? -1 : 0
  robo_y += robo_move == 94 ? 1 : robo_move == 118 ? -1 : 0
  houses[[robo_x, robo_y]] = 1 if robo_move
}
p houses.size
