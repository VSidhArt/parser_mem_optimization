# frozen_string_literal: true

require 'benchmark'
require_relative '../deoptimized.rb'
require_relative '../optimized.rb'

time = Benchmark.realtime do
  ARGV.include?('deopt') ? Deoptimized.work : Optimized.work
end

puts "Finish in #{time.round(2)}"
