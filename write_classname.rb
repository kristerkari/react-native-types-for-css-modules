Dir["**/*.d.ts"].each{|d|
    modified = `ruby add_classname.rb #{d}`
    File.open(d, 'w') {|f| f.write(modified.gsub(/\r\n?/,"\n")); f.close }
}
