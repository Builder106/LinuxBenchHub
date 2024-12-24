class PerformanceBenchmark < ApplicationRecord
   serialize :benchmarks, JSON
   serialize :results, JSON
 
   belongs_to :user
 
   validates :name, presence: true
   validates :linux_os, presence: true
   validates :benchmarks, presence: true
   validates :description, presence: true
   validates :results, presence: true
 end