require './task.rb'
require 'ruby-prof'

# RubyProf.measure_mode = RubyProf::WALL_TIME
# RubyProf.measure_mode = RubyProf::PROCESS_TIME
# RubyProf.measure_mode = RubyProf::ALLOCATIONS
RubyProf.measure_mode = RubyProf::MEMORY

result = RubyProf.profile do
  work
end

# printer = RubyProf::FlatPrinter.new(result)
# printer.print(File.open("reports/ruby_prof_origin.txt", "w+"))

# printer = RubyProf::GraphPrinter.new(result)
# printer.print(File.open("reports/ruby_prof_origin.dot", "w+"))
#
# printer = RubyProf::GraphHtmlPrinter.new(result)
# printer.print(File.open("reports/ruby_prof_origin.html", "w+"))

printer = RubyProf::CallTreePrinter.new(result)
printer.print(:path => "../reports", :profile => 'ruby_prof_origin_tree')
