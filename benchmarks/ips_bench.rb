# frozen_string_literal: true

require 'benchmark/ips'
require_relative '../optimized.rb'
require_relative '../deoptimized.rb'

REPEAT = 10_000
Benchmark.ips do |x|
  # x.report('deotimized') {  }
  # x.report('optimized') { Optimized.work('data/data_10_000.txt') }

  # x.report('brackets') { REPEAT.times { [*1..100] } }
  # x.report('new') { REPEAT.times { Array.new([*1..100]) } }

  #x.report('proc') { REPEAT .times {  x = Proc.new {|i| i**2 }; x.call(2) } }
  #x.report('lambda') { REPEAT.times { x = lambda {|x| x**2 }; x.call(2)  } }

  #arr1 = Array.new
  #arr2 = Array.new
  #x.report('sync') { REPEAT.times { arr1 << 1 } }
  #x.report('async') do
    #10.times.map do
      #Thread.new do
        #10000.times { arr2 << 1 }
      #end
    #end.each(&:join)
  #end

  arr = [*1..1000]
  x.report('first') { REPEAT.times { arr.first } }
  x.report('splat') { REPEAT.times { first, *rest = arr } }
  x.compare!
end
