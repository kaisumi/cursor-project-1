require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }
  let!(:post_item) { create(:post, user: user) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  describe '投稿一覧' do
    before { visit posts_path }

    it '投稿が表示されること' do
      expect(page).to have_content(post_item.title)
      expect(page).to have_content(post_item.content)
    end

    it 'ログイン時に新規投稿リンクが表示されること' do
      sign_in user
      visit posts_path
      expect(page).to have_link('新規投稿', href: new_post_path)
    end
  end

  describe '投稿作成' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit new_post_path
      end

      it '有効な入力で投稿が作成されること' do
        fill_in 'post[title]', with: '新しい投稿'
        fill_in 'post[content]', with: '投稿の本文です'
        click_button '登録する'

        expect(page).to have_content('投稿を作成しました')
        expect(page).to have_content('新しい投稿')
        expect(page).to have_content('投稿の本文です')
      end

      it '無効な入力でバリデーションエラーが表示されること' do
        fill_in 'post[title]', with: ''
        fill_in 'post[content]', with: ''
        click_button '登録する'

        expect(page).to have_content('入力内容にエラーがあります')
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit new_post_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe '投稿編集' do
    context '投稿者本人の場合' do
      before do
        sign_in user
        visit edit_post_path(post_item)
      end

      it '有効な入力で投稿が更新されること' do
        fill_in 'post[title]', with: '更新された投稿'
        fill_in 'post[content]', with: '更新された本文です'
        click_button '更新する'

        expect(page).to have_content('投稿を更新しました')
        expect(page).to have_content('更新された投稿')
        expect(page).to have_content('更新された本文です')
      end

      it '無効な入力でバリデーションエラーが表示されること' do
        fill_in 'post[title]', with: ''
        click_button '更新する'

        expect(page).to have_content('入力内容にエラーがあります')
      end
    end

    context '投稿者以外のユーザーの場合' do
      let(:other_user) { create(:user) }

      it '編集ページにアクセスできないこと' do
        sign_in other_user
        visit edit_post_path(post_item)
        expect(page).to have_current_path(posts_path)
        expect(page).to have_content('権限がありません')
      end
    end
  end

  describe '投稿削除' do
    context '投稿者本人の場合' do
      before do
        sign_in user
        visit post_path(post_item)
      end

      it '投稿が削除されること' do
        accept_confirm do
          click_button '削除'
        end

        expect(page).to have_content('投稿を削除しました')
        expect(page).not_to have_content(post_item.title)
      end
    end

    context '投稿者以外のユーザーの場合' do
      let(:other_user) { create(:user) }

      it '削除ボタンが表示されないこと' do
        sign_in other_user
        visit post_path(post_item)
        expect(page).not_to have_button('削除')
      end
    end
  end

  describe '投稿詳細' do
    before { visit post_path(post_item) }

    it '投稿の詳細が表示されること' do
      expect(page).to have_content(post_item.title)
      expect(page).to have_content(post_item.content)
      expect(page).to have_content(post_item.user.name)
    end

    context '投稿者本人の場合' do
      before do
        sign_in user
        visit post_path(post_item)
      end

      it '編集・削除ボタンが表示されること' do
        expect(page).to have_link('編集', href: edit_post_path(post_item))
        expect(page).to have_button('削除')
      end
    end

    context '投稿者以外のユーザーの場合' do
      before do
        sign_in create(:user)
        visit post_path(post_item)
      end

      it '編集・削除ボタンが表示されないこと' do
        expect(page).not_to have_link('編集')
        expect(page).not_to have_button('削除')
      end
    end
  end
end
