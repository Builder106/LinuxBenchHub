require "test_helper"

# The route resource is `performance_benchmarks` (PerformanceBenchmarksController).
# index / show / new / create are public; the destructive + per-user actions sit
# behind Devise authentication. (Replaces the old benchmarks_controller_test.rb
# stub, whose generated URL helpers never matched this resource.)
class PerformanceBenchmarksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index is public and renders" do
    get performance_benchmarks_url
    assert_response :success
  end

  test "new is public and renders" do
    get new_performance_benchmark_url
    assert_response :success
  end

  test "show is public and renders a benchmark" do
    get performance_benchmark_url(performance_benchmarks(:one))
    assert_response :success
  end

  test "create persists a benchmark and redirects to it" do
    sign_in users(:one)
    assert_difference("PerformanceBenchmark.count", 1) do
      post performance_benchmarks_url, params: {
        performance_benchmark: { name: "New Suite", linux_os: "Debian 12", benchmarks: %w[CPU] }
      }
    end
    assert_redirected_to performance_benchmark_url(PerformanceBenchmark.last)
  end

  test "destroy requires authentication" do
    assert_no_difference("PerformanceBenchmark.count") do
      delete performance_benchmark_url(performance_benchmarks(:one))
    end
    assert_redirected_to new_user_session_path
  end

  test "authenticated user can destroy a benchmark" do
    sign_in users(:one)
    assert_difference("PerformanceBenchmark.count", -1) do
      delete performance_benchmark_url(performance_benchmarks(:one))
    end
    assert_redirected_to performance_benchmarks_url
  end
end
