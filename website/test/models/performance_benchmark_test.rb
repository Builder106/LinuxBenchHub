require "test_helper"

class PerformanceBenchmarkTest < ActiveSupport::TestCase
  def valid_attrs(overrides = {})
    { name: "CPU Suite", linux_os: "Ubuntu 24.04", benchmarks: %w[CPU Memory] }.merge(overrides)
  end

  test "is valid with name, linux_os, and benchmarks" do
    assert PerformanceBenchmark.new(valid_attrs).valid?
  end

  test "requires a name" do
    b = PerformanceBenchmark.new(valid_attrs(name: nil))
    assert_not b.valid?
    assert_includes b.errors[:name], "can't be blank"
  end

  test "requires a linux_os" do
    b = PerformanceBenchmark.new(valid_attrs(linux_os: nil))
    assert_not b.valid?
    assert_includes b.errors[:linux_os], "can't be blank"
  end

  test "requires benchmarks" do
    b = PerformanceBenchmark.new(valid_attrs(benchmarks: nil))
    assert_not b.valid?
    assert_includes b.errors[:benchmarks], "can't be blank"
  end

  test "user is optional" do
    assert PerformanceBenchmark.new(valid_attrs).valid?, "should be valid with no associated user"
  end

  test "serializes benchmarks and results as JSON on round-trip" do
    b = PerformanceBenchmark.create!(valid_attrs(benchmarks: %w[CPU], results: { "cpu" => "Pass" }))
    reloaded = PerformanceBenchmark.find(b.id)
    assert_equal %w[CPU], reloaded.benchmarks
    assert_equal({ "cpu" => "Pass" }, reloaded.results)
  end

  test "to_csv emits a header row and the record's values" do
    b = performance_benchmarks(:one)
    rows = CSV.parse(b.to_csv)
    assert_equal %w[id name linux_os benchmarks created_at], rows.first
    assert_equal b.id.to_s, rows.second.first
    assert_equal b.name, rows.second[1]
    assert_equal b.linux_os, rows.second[2]
  end
end
