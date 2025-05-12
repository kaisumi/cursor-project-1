require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should not save post without title" do
    post = Post.new
    assert_not post.save, "Saved post without title"
  end

  test "should not save post without content" do
    post = Post.new(title: "Test Post")
    assert_not post.save, "Saved post without content"
  end

  test "should not save post without user" do
    post = Post.new(title: "Test Post", content: "Test Content")
    assert_not post.save, "Saved post without user"
  end

  test "should save post with valid attributes" do
    user = User.create(email: "test@example.com", encrypted_password: "password")
    post = Post.new(title: "Test Post", content: "Test Content", user: user)
    assert post.save, "Could not save post with valid attributes"
  end
end
