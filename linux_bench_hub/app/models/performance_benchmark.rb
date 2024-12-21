class PerformanceBenchmark < ApplicationRecord
   serialize :benchmarks, Array
 
   validates :name, presence: true
   validates :linux_os, presence: true
   validates :benchmarks, presence: true
 end