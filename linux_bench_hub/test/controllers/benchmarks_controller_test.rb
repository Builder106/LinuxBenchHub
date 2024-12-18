require "test_helper"

class BenchmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get benchmarks_index_url
    assert_response :success
  end

  test "should get show" do
    get benchmarks_show_url
    assert_response :success
  end

  test "should get new" do
    get benchmarks_new_url
    assert_response :success
  end

  test "should get create" do
    get benchmarks_create_url
    assert_response :success
  end
end
