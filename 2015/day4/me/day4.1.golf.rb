require 'digest'
key=gets
i=-1
i+=1 until Digest::MD5.hexdigest(key+i.to_s)[/^0{5}/]
puts i
