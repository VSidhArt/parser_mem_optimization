require_relative '../task.rb'

def print_object_space_count_objects
  "count_objects: #{ObjectSpace.count_objects}"
end

before_total_object = ObjectSpace.count_objects[:TOTAL]
puts "Before: #{print_object_space_count_objects}"
work
after_total_object = ObjectSpace.count_objects[:TOTAL]
puts "After: #{print_object_space_count_objects}"
puts "Total objects diff: #{after_total_object - before_total_object}"
