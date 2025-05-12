require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }
  let!(:post_item) { create(:post, user: user, title: 'テスト投稿', content: 'これはテスト投稿です。') }

  describe '投稿一覧' do
    before do
      visit posts_path
    end

    it '投稿一覧が表示されること' do
      expect(page).to have_content('投稿一覧')
      expect(page).to have_content('テスト投稿')
      expect(page).to have_content('これはテスト投稿です。')
    end

    context 'ログインしている場合' do
      before do
        sign_in user
        visit posts_path
      end

      it '新規投稿リンクが表示されること' do
        expect(page).to have_link('新規投稿')
      end

      it '自分の投稿に編集・削除リンクが表示されること' do
        expect(page).to have_link('編集')
        expect(page).to have_button('削除')
      end
    end

    context 'ログインしていない場合' do
      it '新規投稿リンクが表示されないこと' do
        expect(page).not_to have_link('新規投稿')
      end

      it '編集・削除リンクが表示されないこと' do
        expect(page).not_to have_link('編集')
        expect(page).not_to have_button('削除')
      end
    end
  end

  describe '投稿詳細' do
    before do
      visit post_path(post_item)
    end

    it '投稿の詳細が表示されること' do
      expect(page).to have_content('テスト投稿')
      expect(page).to have_content('これはテスト投稿です。')
      expect(page).to have_content(user.name)
    end

    context 'ログインしている場合' do
      before do
        sign_in user
        visit post_path(post_item)
      end

      it '自分の投稿に編集・削除リンクが表示されること' do
        expect(page).to have_link('編集')
        expect(page).to have_button('削除')
      end

      it 'コメントフォームが表示されること' do
        expect(page).to have_button('コメントする')
      end
    end

    context 'ログインしていない場合' do
      it '編集・削除リンクが表示されないこと' do
        expect(page).not_to have_link('編集')
        expect(page).not_to have_button('削除')
      end

      it 'コメントフォームが表示されないこと' do
        expect(page).not_to have_button('コメントする')
      end
    end
  end

  describe '新規投稿' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit new_post_path
      end

      it '新規投稿フォームが表示されること' do
        expect(page).to have_field('post[title]')
        expect(page).to have_field('post[content]')
      end

      context '有効な値を入力した場合' do
        it '投稿が作成されること' do
          fill_in 'post[title]', with: '新しい投稿'
          fill_in 'post[content]', with: '新しい投稿の内容です。'
          click_button '登録する'

          expect(page).to have_content('投稿を作成しました')
          expect(page).to have_content('新しい投稿')
          expect(page).to have_content('新しい投稿の内容です。')
        end
      end

      context '無効な値を入力した場合' do
        it 'エラーメッセージが表示されること' do
          fill_in 'post[title]', with: ''
          fill_in 'post[content]', with: ''
          click_button '登録する'

          expect(page).to have_content('入力内容にエラーがあります')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit new_post_path
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe '投稿編集' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit edit_post_path(post_item)
      end

      it '編集フォームが表示されること' do
        expect(page).to have_field('post[title]', with: 'テスト投稿')
        expect(page).to have_field('post[content]', with: 'これはテスト投稿です。')
      end

      context '有効な値を入力した場合' do
        it '投稿が更新されること' do
          fill_in 'post[title]', with: '更新された投稿'
          fill_in 'post[content]', with: '更新された投稿の内容です。'
          click_button '更新する'

          expect(page).to have_content('投稿を更新しました')
          expect(page).to have_content('更新された投稿')
          expect(page).to have_content('更新された投稿の内容です。')
        end
      end

      context '無効な値を入力した場合' do
        it 'エラーメッセージが表示されること' do
          fill_in 'post[title]', with: ''
          fill_in 'post[content]', with: ''
          click_button '更新する'

          expect(page).to have_content('入力内容にエラーがあります')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        visit edit_post_path(post_item)
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe '投稿削除' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit post_path(post_item)
      end

      it '投稿が削除されること', :js do
        accept_confirm do
          click_button '削除'
        end

        expect(page).to have_content('投稿を削除しました')
        expect(page).not_to have_content('テスト投稿')
      end
    end

    context 'ログインしていない場合' do
      it '削除ボタンが表示されないこと' do
        visit post_path(post_item)
        expect(page).not_to have_button('削除')
      end
    end
  end
end
