require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(10000) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
  end

  describe '#editable_by?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:post) { create(:post, user: user) }

    context 'when user is the author' do
      it 'returns true' do
        expect(post.editable_by?(user)).to be true
      end
    end

    context 'when user is not the author' do
      it 'returns false' do
        expect(post.editable_by?(other_user)).to be false
      end
    end

    context 'when user is nil' do
      it 'returns false' do
        expect(post.editable_by?(nil)).to be false
      end
    end
  end

  describe '#liked_by?' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    context 'when user has liked the post' do
      before { create(:like, user: user, post: post) }

      it 'returns true' do
        expect(post.liked_by?(user)).to be true
      end
    end

    context 'when user has not liked the post' do
      it 'returns false' do
        expect(post.liked_by?(user)).to be false
      end
    end

    context 'when user is nil' do
      it 'returns false' do
        expect(post.liked_by?(nil)).to be false
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(create(:post)).to be_valid
    end

    it 'creates post with comments' do
      post = create(:post, :with_comments)
      expect(post.comments.count).to eq 3
    end

    it 'creates post with likes' do
      post = create(:post, :with_likes)
      expect(post.likes.count).to eq 3
    end
  end
end
