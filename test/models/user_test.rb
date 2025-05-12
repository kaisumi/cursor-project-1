require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new
    assert_not user.save, "Saved user without email"
  end

  test "should not save user without encrypted_password" do
    user = User.new(email: "test@example.com")
    assert_not user.save, "Saved user without encrypted_password"
  end

  test "should save user with valid attributes" do
    user = User.new(email: "test@example.com", encrypted_password: "password")
    assert user.save, "Could not save user with valid attributes"
  end
end
