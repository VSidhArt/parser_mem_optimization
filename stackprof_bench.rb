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
require './task.rb'
require 'stackprof'

StackProf.run(mode: :object, out: 'reports/stackprof_origin.dump', raw: true) do
  work
end
