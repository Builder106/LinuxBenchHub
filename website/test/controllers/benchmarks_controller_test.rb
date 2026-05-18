require "test_helper"

# Scaffold leftover: the real resource is PerformanceBenchmarksController, mounted
# under `resources :performance_benchmarks` (see config/routes.rb). The original
# generated tests referenced URL helpers that don't exist for that resource and
# hit endpoints behind Devise auth. Replace with real coverage when sign-in
# helpers and route fixtures are added.
class BenchmarksControllerTest < ActionDispatch::IntegrationTest
end
