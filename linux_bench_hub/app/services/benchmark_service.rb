class BenchmarkService
   def self.run_benchmark(name)
     # Code to run benchmark and collect data
     data = `your_benchmarking_command`
     Benchmark.create(name: name, data: data)
   end
 end