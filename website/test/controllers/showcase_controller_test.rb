require "test_helper"

class ShowcaseControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get showcase_url
    assert_response :success
  end

  test "should get show for each known distro" do
    BenchmarkReport::DISTROS.each do |slug|
      get showcase_distro_url(distro: slug)
      assert_response :success
    end
  end

  test "should 404 for an unknown distro" do
    get showcase_distro_url(distro: "arch")
    assert_response :not_found
  end
end
