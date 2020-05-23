# frozen_string_literal: true

require 'ruby-prof'
require_relative '../deoptimized.rb'
require_relative '../optimized.rb'

RubyProf.measure_mode = RubyProf::WALL_TIME
# RubyProf.measure_mode = RubyProf::PROCESS_TIME
# RubyProf.measure_mode = RubyProf::ALLOCATIONS
# RubyProf.measure_mode = RubyProf::MEMORY

result = RubyProf.profile do
  ARGV.include?('deopt') ? Deoptimized.work : Optimized.work
end

# printer = RubyProf::FlatPrinter.new(result)
# printer.print(File.open("reports/ruby_prof_origin.txt", "w+"))

# printer = RubyProf::GraphPrinter.new(result)
# printer.print(File.open("reports/ruby_prof_origin.dot", "w+"))
#
#printer = RubyProf::GraphHtmlPrinter.new(result)
#printer.print(File.open('reports/ruby_prof_origin.html', 'w+'))

 printer = RubyProf::CallTreePrinter.new(result)
 printer.print(:path => "./reports", :profile => 'ruby_prof_origin_tree')

#printer = RubyProf::CallStackPrinter.new(result)
#printer.print(File.open('reports/ruby_prof_call_stack.html', 'w+'))
