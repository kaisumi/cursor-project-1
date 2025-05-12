require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { build(:post, user: user) }

  describe 'バリデーション' do
    it '有効な属性値の場合は有効であること' do
      expect(post).to be_valid
    end

    describe 'title' do
      it '存在しない場合は無効であること' do
        post.title = nil
        expect(post).to be_invalid
      end

      it '100文字を超える場合は無効であること' do
        post.title = 'a' * 101
        expect(post).to be_invalid
      end

      it '100文字以内の場合は有効であること' do
        post.title = 'a' * 100
        expect(post).to be_valid
      end
    end

    describe 'content' do
      it '存在しない場合は無効であること' do
        post.content = nil
        expect(post).to be_invalid
      end

      it '10000文字を超える場合は無効であること' do
        post.content = 'a' * 10001
        expect(post).to be_invalid
      end

      it '10000文字以内の場合は有効であること' do
        post.content = 'a' * 10000
        expect(post).to be_valid
      end
    end

    it 'user_idが存在しない場合は無効であること' do
      post.user_id = nil
      expect(post).to be_invalid
    end
  end

  describe 'アソシエーション' do
    it 'userに属していること' do
      expect(post.user).to eq user
    end

    it 'コメントを複数持つこと' do
      expect(post).to respond_to(:comments)
    end

    it 'いいねを複数持つこと' do
      expect(post).to respond_to(:likes)
    end

    it '削除時に関連するコメントも削除されること' do
      post.save
      create(:comment, post: post)
      expect { post.destroy }.to change(Comment, :count).by(-1)
    end

    it '削除時に関連するいいねも削除されること' do
      post.save
      create(:like, post: post)
      expect { post.destroy }.to change(Like, :count).by(-1)
    end
  end

  describe '#editable_by?' do
    context '投稿者本人の場合' do
      it 'trueを返すこと' do
        expect(post.editable_by?(user)).to be true
      end
    end

    context '投稿者以外のユーザーの場合' do
      let(:other_user) { create(:user) }

      it 'falseを返すこと' do
        expect(post.editable_by?(other_user)).to be false
      end
    end

    context 'ユーザーがnilの場合' do
      it 'falseを返すこと' do
        expect(post.editable_by?(nil)).to be false
      end
    end
  end

  describe '#liked_by?' do
    let(:other_user) { create(:user) }

    before do
      post.save
    end

    context 'ユーザーが投稿にいいねしている場合' do
      before do
        create(:like, post: post, user: other_user)
      end

      it 'trueを返すこと' do
        expect(post.liked_by?(other_user)).to be true
      end
    end

    context 'ユーザーが投稿にいいねしていない場合' do
      it 'falseを返すこと' do
        expect(post.liked_by?(other_user)).to be false
      end
    end

    context 'ユーザーがnilの場合' do
      it 'falseを返すこと' do
        expect(post.liked_by?(nil)).to be false
      end
    end
  end
end
