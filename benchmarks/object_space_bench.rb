# frozen_string_literal: true

require_relative '../deoptimized.rb'
require_relative '../optimized.rb'

def print_object_space_count_objects
  "count_objects: #{ObjectSpace.count_objects}"
end

before_total_object = ObjectSpace.count_objects[:TOTAL]
puts "Before: #{print_object_space_count_objects}"
ARGV.include?('deopt') ? Deoptimized.work : Optimized.work
after_total_object = ObjectSpace.count_objects[:TOTAL]
puts "After: #{print_object_space_count_objects}"
puts "Total objects diff: #{after_total_object - before_total_object}"
