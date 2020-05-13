require 'benchmark'
require './task.rb'

time = Benchmark.realtime do
  work
end

puts "Finish in #{time.round(2)}"
