require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects to the sign-in page when not authenticated" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  # KNOWN BUG (not asserted here): an authenticated GET /dashboard currently
  # 500s. DashboardController#index calls `performance_benchmarks.average(:score)`
  # and app/views/dashboard/index.html.erb renders `benchmark.score`, but there
  # is no `score` column on performance_benchmarks (see db/schema.rb). Add an
  # authenticated success assertion once the column is added or the `score`
  # references are removed.
end
