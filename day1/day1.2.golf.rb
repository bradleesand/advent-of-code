m=Hash.new 0;$stdin.each_char.with_index{|c,p|m[c]+=1;m.values.reduce(:-)==-1&&puts(p+1)}
