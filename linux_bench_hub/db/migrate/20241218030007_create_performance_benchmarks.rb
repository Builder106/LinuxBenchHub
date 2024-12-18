class CreatePerformanceBenchmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :performance_benchmarks do |t|
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
