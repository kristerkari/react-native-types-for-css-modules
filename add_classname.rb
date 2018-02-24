ARGF.each do |line|
  puts line
  puts "", "    className?: string;" if line =~ /style\?: StyleProp<.*Style>;/
end
