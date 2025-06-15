class AddLinuxOsAndBenchmarksToPerformanceBenchmarks < ActiveRecord::Migration[8.0]
  def change
    add_column :performance_benchmarks, :linux_os, :string
    add_column :performance_benchmarks, :benchmarks, :text
  end
end
