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

    it 'is not valid with an invalid email format' do
      user = build(:user, email: 'invalid-email')
      expect(user).not_to be_valid
    end

    it 'is valid with a name' do
      user = build(:user, name: 'テスト太郎')
      expect(user).to be_valid
    end

    it 'is valid without a name' do
      user = build(:user, name: nil)
      expect(user).to be_valid
    end

    it 'is not valid with a name longer than 50 characters' do
      user = build(:user, name: 'a' * 51)
      expect(user).not_to be_valid
    end
  end
end
