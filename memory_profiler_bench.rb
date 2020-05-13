require './task.rb'
require 'memory_profiler'

report = MemoryProfiler.report do
  work
end

report.pretty_print(scale_bytes: true, to_file: 'reports/memory_profiler_origin')

