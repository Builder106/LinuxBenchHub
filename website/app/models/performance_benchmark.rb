require 'csv'

class PerformanceBenchmark < ApplicationRecord
   belongs_to :user, optional: true
 
   # Specify the coder using keyword arguments
   serialize :benchmarks, coder: JSON
   serialize :results, coder: JSON
   serialize :data, coder: JSON
 
   validates :name, presence: true
   validates :linux_os, presence: true
   validates :benchmarks, presence: true

   def to_csv
      attributes = %w{id name linux_os benchmarks  created_at}
      
      CSV.generate(headers: true) do |csv|
        csv << attributes
        csv << attributes.map{ |attr| self.send(attr) }
      end
   end
end