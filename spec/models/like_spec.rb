require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  
  it "allows a user to like a post" do
    like = Like.new(user: user, post: post)
    expect(like).to be_valid
  end
  
  it "does not allow duplicate likes" do
    Like.create(user: user, post: post)
    like = Like.new(user: user, post: post)
    expect(like).not_to be_valid
  end
end
