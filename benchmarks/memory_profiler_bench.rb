require './task.rb'
require 'memory_profiler'

report = MemoryProfiler.report do
  work
end

report.pretty_print(scale_bytes: true)

