require "test_helper"

class BenchmarksControllerTest < ActionDispatch::IntegrationTest
  test "renders every distro writeup" do
    DistroBenchmark::DISTROS.each do |slug|
      get benchmark_url(distro: slug)
      assert_response :success
      assert_select ".distro-hero-name", text: /#{DistroBenchmark.meta(slug)[:name]}/
      assert_select ".bench-card", minimum: 1
    end
  end

  test "unknown distro is not routable" do
    assert_raises(ActionController::UrlGenerationError) do
      benchmark_url(distro: "arch")
    end
  end
end
