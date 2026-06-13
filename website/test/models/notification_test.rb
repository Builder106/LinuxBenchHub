require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "requires an associated user" do
    n = Notification.new(message: "Build finished", read: false)
    assert_not n.valid?
    assert_includes n.errors[:user], "must exist"
  end

  test "unread scope returns only notifications with read = false" do
    read_note = notifications(:one)
    read_note.update!(read: true)
    unread = Notification.unread
    assert_includes unread, notifications(:two)
    assert_not_includes unread, read_note
  end
end
