require 'digest'
key=$stdin.read
i=-1
i+=1 until Digest::MD5.hexdigest("#{key}#{i}")[/^0{5}/]
puts i
