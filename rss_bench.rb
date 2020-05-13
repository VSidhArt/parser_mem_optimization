require './task.rb'

puts "Before #{"%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)}"
work
puts "After #{"%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)}"


