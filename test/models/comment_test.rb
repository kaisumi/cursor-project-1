require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without content" do
    comment = Comment.new
    assert_not comment.save, "Saved comment without content"
  end

  test "should not save comment without user" do
    comment = Comment.new(content: "Test Comment")
    assert_not comment.save, "Saved comment without user"
  end

  test "should not save comment without post" do
    user = User.create(email: "test@example.com", encrypted_password: "password")
    comment = Comment.new(content: "Test Comment", user: user)
    assert_not comment.save, "Saved comment without post"
  end

  test "should save comment with valid attributes" do
    user = User.create(email: "test@example.com", encrypted_password: "password")
    post = Post.create(title: "Test Post", content: "Test Content", user: user)
    comment = Comment.new(content: "Test Comment", user: user, post: post)
    assert comment.save, "Could not save comment with valid attributes"
  end
end
