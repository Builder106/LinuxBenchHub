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

  test "should get show for each known distro on arm64" do
    BenchmarkReport::DISTROS.each do |slug|
      get showcase_distro_arch_url(distro: slug, arch: "arm64")
      assert_response :success
    end
  end

  test "should 404 for an unknown arch" do
    get "/showcase/ubuntu/riscv64"
    assert_response :not_found
  end
end
