require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }
  let!(:post_item) { create(:post, user: user) }
  let(:other_user) { create(:user) }

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
        fill_in name: 'post[title]', with: 'テスト投稿'
        fill_in name: 'post[content]', with: 'これはテスト投稿の内容です。'
        click_button '登録する'
        expect(page).to have_content('投稿が作成されました。')
      end

      it '無効な入力でバリデーションエラーが表示されること' do
        fill_in name: 'post[title]', with: ''
        fill_in name: 'post[content]', with: ''
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
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before do
          sign_in user
          visit post_path(post_item)
        end

        it '編集リンクが表示されること' do
          expect(page).to have_link('編集')
        end

        it '投稿を編集できること' do
          click_link '編集'
          fill_in name: 'post[title]', with: '更新されたタイトル'
          fill_in name: 'post[content]', with: '更新された内容'
          click_button '更新する'
          expect(page).to have_content('更新されたタイトル')
          expect(page).to have_content('更新された内容')
        end

        it '無効な入力で編集できないこと' do
          click_link '編集'
          fill_in name: 'post[title]', with: ''
          click_button '更新する'
          expect(page).to have_content('タイトルを入力してください')
        end
      end

      context '投稿の作成者でない場合' do
        before do
          sign_in other_user
          visit post_path(post_item)
        end

        it '編集リンクが表示されないこと' do
          expect(page).not_to have_link('編集')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post_item) }

      it '編集リンクが表示されないこと' do
        expect(page).not_to have_link('編集')
      end
    end
  end

  describe '投稿削除' do
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before do
          sign_in user
          visit post_path(post_item)
        end

        it '削除ボタンが表示されること' do
          expect(page).to have_button('削除')
        end

        it '確認ダイアログが表示されること' do
          click_button '削除'
          expect(page).to have_content('この投稿を削除してもよろしいですか？')
        end

        it '投稿を削除できること' do
          click_button '削除'
          click_button '削除する'
          expect(page).to have_content('投稿が削除されました。')
          expect(page).not_to have_content(post_item.title)
        end

        it 'キャンセルで削除を中止できること' do
          click_button '削除'
          click_button 'キャンセル'
          expect(page).to have_content(post_item.title)
        end
      end

      context '投稿の作成者でない場合' do
        before do
          sign_in other_user
          visit post_path(post_item)
        end

        it '削除ボタンが表示されないこと' do
          expect(page).not_to have_button('削除する')
        end
      end
    end

    context 'ログインしていない場合' do
      before { visit post_path(post_item) }

      it '削除ボタンが表示されないこと' do
        expect(page).not_to have_button('削除する')
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
        expect(page).not_to have_button('削除する')
      end
    end
  end
end
