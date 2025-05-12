require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user)
      post = create(:post, user: user)
      comment = build(:comment, user: user, post: post)
      expect(comment).to be_valid
    end

    it 'is not valid without content' do
      comment = build(:comment, content: nil)
      expect(comment).not_to be_valid
    end

    it 'is not valid without a user' do
      comment = build(:comment, user: nil)
      expect(comment).not_to be_valid
    end

    it 'is not valid without a post' do
      comment = build(:comment, post: nil)
      expect(comment).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a post' do
      association = described_class.reflect_on_association(:post)
      expect(association.macro).to eq :belongs_to
    end
  end
end
