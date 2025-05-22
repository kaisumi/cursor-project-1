require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  
  it "allows a user to follow another user" do
    relationship = Relationship.new(follower: user1, followed: user2)
    expect(relationship).to be_valid
  end
  
  it "does not allow duplicate relationships" do
    Relationship.create(follower: user1, followed: user2)
    relationship = Relationship.new(follower: user1, followed: user2)
    expect(relationship).not_to be_valid
  end
end
