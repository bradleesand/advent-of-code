# Read input and count up parens minus down parens
input = $<.read
p input.count('(') - input.count(')')
