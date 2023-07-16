ARGF.each do |line|
  puts line
  # puts "", "    className?: string;" if line =~ /style\?: StyleProp<.*Style>;/
  # Since @types/react-native v0.64.11, `style` is added to `undefined`.
  puts "", "  className?: string;" if line =~ /style\?: StyleProp<.* \| undefined;/
end
