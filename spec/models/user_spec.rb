require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many posts' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end

    it 'has many comments' do
      association = described_class.reflect_on_association(:comments)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'devise overrides' do
    let(:user) { build(:user) }

    it 'does not require a password on create' do
      user.password = nil
      user.password_confirmation = nil
      expect(user.valid?).to be_truthy
    end

    it 'requires an email' do
      user.email = nil
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  describe 'following and followers' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.follow(other_user)
    end

    it 'can follow another user' do
      expect(user.following?(other_user)).to be_truthy
    end

    it 'can unfollow a user' do
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end

    it 'has the right following and followers' do
      expect(user.following).to include(other_user)
      expect(other_user.followers).to include(user)
    end
  end
end
