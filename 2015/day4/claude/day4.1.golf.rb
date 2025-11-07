#!/usr/bin/env ruby

require 'digest'

# Part 1: Find lowest number producing MD5 hash with 5 leading zeros
secret = $<.read.strip
n = 0
n += 1 until Digest::MD5.hexdigest("#{secret}#{n}").start_with?('00000')
p n
