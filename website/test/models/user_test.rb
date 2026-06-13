require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with an email and password" do
    assert User.new(email: "new@example.com", password: "password123").valid?
  end

  test "requires an email" do
    u = User.new(password: "password123")
    assert_not u.valid?
    assert_includes u.errors[:email], "can't be blank"
  end

  test "requires a unique email" do
    dup = User.new(email: users(:one).email, password: "password123")
    assert_not dup.valid?
    assert_includes dup.errors[:email], "has already been taken"
  end

  test "destroying a user destroys its benchmarks and notifications" do
    user = users(:one)
    bcount = user.performance_benchmarks.count
    ncount = user.notifications.count
    assert bcount.positive?, "fixture user should own benchmarks"
    assert ncount.positive?, "fixture user should own notifications"
    assert_difference("PerformanceBenchmark.count" => -bcount, "Notification.count" => -ncount) do
      user.destroy
    end
  end
end
