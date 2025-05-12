require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user)
      post = build(:post, user: user)
      expect(post).to be_valid
    end

    it 'is not valid without a title' do
      post = build(:post, title: nil)
      expect(post).not_to be_valid
    end

    it 'is not valid without content' do
      post = build(:post, content: nil)
      expect(post).not_to be_valid
    end

    it 'is not valid without a user' do
      post = build(:post, user: nil)
      expect(post).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many comments' do
      association = described_class.reflect_on_association(:comments)
      expect(association.macro).to eq :has_many
    end
  end
end
