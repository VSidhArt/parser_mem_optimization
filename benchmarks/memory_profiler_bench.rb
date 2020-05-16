require 'memory_profiler'
require_relative '../deoptimized.rb'
require_relative '../optimized.rb'

report = MemoryProfiler.report do
  ARGV.include?("deopt") ? Deoptimized.work : Optimized.work
end

report.pretty_print(scale_bytes: true)

