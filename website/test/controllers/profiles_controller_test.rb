require "test_helper"

# profiles/edit and profiles/update both sit behind Devise auth.
class ProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "edit requires authentication" do
    get profiles_edit_path
    assert_redirected_to new_user_session_path
  end

  test "update requires authentication" do
    get profiles_update_path, params: { user: { username: "newname" } }
    assert_redirected_to new_user_session_path
  end

  test "authenticated user can view the edit page" do
    sign_in users(:one)
    get profiles_edit_path
    assert_response :success
  end

  test "authenticated update with valid params persists and redirects to the dashboard" do
    sign_in users(:one)
    get profiles_update_path, params: { user: { username: "updated_handle" } }
    assert_redirected_to dashboard_path
    assert_equal "updated_handle", users(:one).reload.username
  end
end
