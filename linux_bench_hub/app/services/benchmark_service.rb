class BenchmarkService
   def self.run_benchmark(name)
     # Example command to run a benchmark (e.g., sysbench CPU test)
     command = "sysbench --test=cpu --cpu-max-prime=20000 run"
     
     # Execute the command and capture the output
     data = `#{command}`
     
     # Create a new Benchmark record with the collected data
     Benchmark.create(name: name, data: data)
   end
 end