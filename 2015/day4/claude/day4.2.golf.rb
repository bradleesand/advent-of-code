#!/usr/bin/env ruby

require 'digest'

# Part 2: Find lowest number producing MD5 hash with 6 leading zeros
secret = $<.read.strip
n = 0
n += 1 until Digest::MD5.hexdigest("#{secret}#{n}").start_with?('000000')
p n
