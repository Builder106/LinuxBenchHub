class PerformanceBenchmark < ApplicationRecord
   serialize :benchmarks, coder: JSON
 
   validates :name, presence: true
   validates :linux_os, presence: true
   validates :benchmarks, presence: true
 end