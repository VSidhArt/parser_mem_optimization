require 'benchmark/ips'
require_relative '../optimized.rb'
require_relative '../deoptimized.rb'

Benchmark.ips do |x|
  x.report("deotimized") { Deoptimized.work }
  x.report("optimized") { Optimized.work }

  x.compare!
end
