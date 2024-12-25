require 'csv'

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

   def to_csv
      attributes = %w{id name description linux_os benchmarks results created_at}
      
      CSV.generate(headers: true) do |csv|
        csv << attributes
        csv << attributes.map{ |attr| self.send(attr) }
      end
    end
 end