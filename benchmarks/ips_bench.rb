# frozen_string_literal: true

require 'benchmark/ips'
require_relative '../optimized.rb'
require_relative '../deoptimized.rb'

Benchmark.ips do |x|
  x.report('deotimized') { Deoptimized.work('data/data_10_000.txt') }
  x.report('optimized') { Optimized.work('data/data_10_000.txt') }

  x.compare!
end
