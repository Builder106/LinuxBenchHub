class PerformanceBenchmark < ApplicationRecord
   belongs_to :user, optional: true
 
   # Specify the coder using keyword arguments
   serialize :benchmarks, coder: JSON
   serialize :results, coder: JSON
 
   validates :name, presence: true
   validates :linux_os, presence: true
   validates :benchmarks, presence: true
   validates :description, presence: true
   validates :results, presence: true
 end