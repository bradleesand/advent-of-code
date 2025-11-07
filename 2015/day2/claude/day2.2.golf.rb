# For each box, calculate ribbon: smallest perimeter + bow (volume)
p $<.sum { |line|
  dimensions = line.split(?x).map(&:to_i).sort
  # Smallest perimeter (2 * smallest two dimensions) + volume for bow
  dimensions[0] * 2 + dimensions[1] * 2 + dimensions[0] * dimensions[1] * dimensions[2]
}
