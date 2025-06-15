class AddUserToPerformanceBenchmarks < ActiveRecord::Migration[6.1]
   def change
     # Allow user_id to be nullable initially
     add_reference :performance_benchmarks, :user, null: true, foreign_key: true
   end
 end