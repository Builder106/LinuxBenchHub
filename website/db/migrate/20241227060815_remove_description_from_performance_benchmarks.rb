class RemoveDescriptionFromPerformanceBenchmarks < ActiveRecord::Migration[8.0]
  def change
    remove_column :performance_benchmarks, :description, :text
  end
end
