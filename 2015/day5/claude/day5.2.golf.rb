#!/usr/bin/env ruby
# Day 5 Part 2: Count nice strings with new rules
# Rules: non-overlapping pair, letter repeats with one between

p $<.count { |string|
  # Check for non-overlapping pair
  has_pair = (0...string.size - 1).any? { |i|
    string[(i + 2)..-1]&.include?(string[i..i + 1])
  }
  # Check for letter that repeats with one letter between (xyx pattern)
  has_pair && string.match?(/(.).\1/)
}
