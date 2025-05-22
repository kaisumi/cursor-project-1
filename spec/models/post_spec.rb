require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  
  it "is valid with valid attributes" do
    post = user.posts.build(content: "Test post")
    expect(post).to be_valid
  end
  
  it "is not valid without content" do
    post = user.posts.build(content: nil)
    expect(post).not_to be_valid
  end
  
  it "is not valid with content longer than 280 characters" do
    post = user.posts.build(content: "a" * 281)
    expect(post).not_to be_valid
  end
  
  it "is not valid without a user" do
    post = Post.new(content: "Test post")
    expect(post).not_to be_valid
  end
end
