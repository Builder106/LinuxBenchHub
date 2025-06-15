class AddDescriptionAndResultsToPerformanceBenchmarks < ActiveRecord::Migration[6.0]
   def change
     # Remove or comment out the line adding 'description'
     # add_column :performance_benchmarks, :description, :text
 
     # Add the 'results' column
     add_column :performance_benchmarks, :results, :text
   end
 end