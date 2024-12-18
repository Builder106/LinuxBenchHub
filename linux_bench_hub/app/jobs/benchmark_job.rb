class BenchmarkJob < ApplicationJob
   queue_as :default
 
   def perform(*args)
     BenchmarkService.run_benchmark(args[0])
   end
 end