require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "contact_email is addressed to the inbox and replies from the sender" do
    contact = { name: "Ada Lovelace", email: "ada@example.com", message: "Hello\nthere" }
    email = ContactMailer.with(contact: contact).contact_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal "New Contact Message", email.subject
    assert_equal ["vaughanolayinka@gmail.com"], email.to
    assert_equal ["ada@example.com"], email.from
    assert_match "Ada Lovelace", email.body.encoded
    assert_match "Hello", email.body.encoded
  end
end
