# frozen_string_literal: true

# Stackprof ObjectAllocations and Flamegraph
# stackprof reports/stackprof_origin.dump --text --limit 3
# stackprof reports/stackprof_origin.dump --method 'Object#work'
#
# Flamegraph
# raw: true
# stackprof --flamegraph reports/stackprof_origin.dump > reports/flamegraph_origin
# stackprof --flamegraph-viewer=reports/flamegraph_origin
#
# dot -Tpng graphviz.dot > graphviz.png
#
require 'stackprof'
require_relative '../deoptimized.rb'
require_relative '../optimized.rb'

StackProf.run(mode: :object, out: 'reports/stackprof_new.dump', raw: true) do
  ARGV.include?('deopt') ? Deoptimized.work : Optimized.work
end
