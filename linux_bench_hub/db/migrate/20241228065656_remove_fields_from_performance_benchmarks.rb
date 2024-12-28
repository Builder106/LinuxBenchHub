class RemoveFieldsFromPerformanceBenchmarks < ActiveRecord::Migration[6.1]
  def change
    remove_column :performance_benchmarks, :data, :text
    remove_column :performance_benchmarks, :updated_at, :datetime
    remove_column :performance_benchmarks, :configuration, :json
  end
end