require_relative '../deoptimized.rb'
require_relative '../optimized.rb'

puts "Before #{"%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)}"
ARGV.include?("deopt") ? Deoptimized.work : Optimized.work
puts "After #{"%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)}"


