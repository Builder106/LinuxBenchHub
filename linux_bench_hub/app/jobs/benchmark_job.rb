class BenchmarkJob < ApplicationJob
  queue_as :default

  def perform(performance_benchmark_id)
    performance_benchmark = PerformanceBenchmark.find(performance_benchmark_id)
    BenchmarkService.run_benchmark(performance_benchmark)
    # Optionally update benchmark status
    performance_benchmark.update(status: 'Completed')
  rescue StandardError => e
    performance_benchmark.update(status: 'Failed')
    Rails.logger.error "Benchmark failed: #{e.message}"
  end
end