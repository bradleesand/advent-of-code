# For each box, calculate surface area + slack (smallest side)
p $<.sum { |line|
  dimensions = line.split(?x).map(&:to_i).sort
  # After sorting: dimensions[0] is smallest, dimensions[2] is largest
  # Surface area: 2*l*w + 2*w*h + 2*h*l, plus slack (smallest side)
  dimensions[0] * dimensions[1] * 3 + dimensions[1] * dimensions[2] * 2 + dimensions[0] * dimensions[2] * 2
}
