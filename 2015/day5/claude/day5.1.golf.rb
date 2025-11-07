#!/usr/bin/env ruby
# Day 5 Part 1: Count nice strings
# Rules: 3+ vowels, double letter, no forbidden substrings (ab, cd, pq, xy)

p $<.count { |string|
  string.scan(/[aeiou]/).size >= 3 &&    # At least 3 vowels
  string.match?(/(.)\1/) &&               # Double letter
  !string.match?(/ab|cd|pq|xy/)           # No forbidden substrings
}
