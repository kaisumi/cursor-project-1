require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_item) { create(:post, user: user) }

  describe 'GET #index' do
    before do
      get :index
    end

    it '正常にレスポンスを返すこと' do
      expect(response).to be_successful
    end

    it '投稿一覧を取得すること' do
      expect(assigns(:posts)).to eq([ post_item ])
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: post_item.id }
    end

    it '正常にレスポンスを返すこと' do
      expect(response).to be_successful
    end

    it '要求された投稿を取得すること' do
      expect(assigns(:post)).to eq(post_item)
    end
  end

  describe 'GET #new' do
    context 'ログインしている場合' do
      before do
        sign_in user
        get :new
      end

      it '正常にレスポンスを返すこと' do
        expect(response).to be_successful
      end

      it '新しい投稿を初期化すること' do
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'ログインしていない場合' do
      before do
        get :new
      end

      it 'ログインページにリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context '有効なパラメータの場合' do
        let(:valid_params) { { post: attributes_for(:post) } }

        it '投稿を作成すること' do
          expect {
            post :create, params: valid_params
          }.to change(Post, :count).by(1)
        end

        it '投稿詳細ページにリダイレクトすること' do
          post :create, params: valid_params
          expect(response).to redirect_to(post_path(Post.last))
        end
      end

      context '無効なパラメータの場合' do
        let(:invalid_params) { { post: attributes_for(:post, title: nil) } }

        it '投稿を作成しないこと' do
          expect {
            post :create, params: invalid_params
          }.not_to change(Post, :count)
        end

        it '新規投稿ページを再表示すること' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        post :create, params: { post: attributes_for(:post) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'ログインしている場合' do
      context '投稿者本人の場合' do
        before do
          sign_in user
          get :edit, params: { id: post_item.id }
        end

        it '正常にレスポンスを返すこと' do
          expect(response).to be_successful
        end

        it '要求された投稿を取得すること' do
          expect(assigns(:post)).to eq(post_item)
        end
      end

      context '投稿者以外のユーザーの場合' do
        before do
          sign_in other_user
          get :edit, params: { id: post_item.id }
        end

        it '投稿一覧ページにリダイレクトすること' do
          expect(response).to redirect_to(posts_path)
        end
      end
    end

    context 'ログインしていない場合' do
      before do
        get :edit, params: { id: post_item.id }
      end

      it 'ログインページにリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { title: '新しいタイトル', content: '新しい内容' } }

    context 'ログインしている場合' do
      context '投稿者本人の場合' do
        before do
          sign_in user
        end

        context '有効なパラメータの場合' do
          before do
            patch :update, params: { id: post_item.id, post: new_attributes }
          end

          it '投稿を更新すること' do
            post_item.reload
            expect(post_item.title).to eq('新しいタイトル')
            expect(post_item.content).to eq('新しい内容')
          end

          it '投稿詳細ページにリダイレクトすること' do
            expect(response).to redirect_to(post_path(post_item))
          end
        end

        context '無効なパラメータの場合' do
          before do
            patch :update, params: { id: post_item.id, post: attributes_for(:post, title: nil) }
          end

          it '投稿を更新しないこと' do
            post_item.reload
            expect(post_item.title).not_to be_nil
          end

          it '編集ページを再表示すること' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context '投稿者以外のユーザーの場合' do
        before do
          sign_in other_user
          patch :update, params: { id: post_item.id, post: new_attributes }
        end

        it '投稿を更新しないこと' do
          post_item.reload
          expect(post_item.title).not_to eq('新しいタイトル')
        end

        it '投稿一覧ページにリダイレクトすること' do
          expect(response).to redirect_to(posts_path)
        end
      end
    end

    context 'ログインしていない場合' do
      before do
        patch :update, params: { id: post_item.id, post: new_attributes }
      end

      it 'ログインページにリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      context '投稿者本人の場合' do
        before do
          sign_in user
        end

        it '投稿を削除すること' do
          post_item # 事前に投稿を作成
          expect {
            delete :destroy, params: { id: post_item.id }
          }.to change(Post, :count).by(-1)
        end

        it '投稿一覧ページにリダイレクトすること' do
          delete :destroy, params: { id: post_item.id }
          expect(response).to redirect_to(posts_path)
        end
      end

      context '投稿者以外のユーザーの場合' do
        before do
          sign_in other_user
        end

        it '投稿を削除しないこと' do
          post_item # 事前に投稿を作成
          expect {
            delete :destroy, params: { id: post_item.id }
          }.not_to change(Post, :count)
        end

        it '投稿一覧ページにリダイレクトすること' do
          delete :destroy, params: { id: post_item.id }
          expect(response).to redirect_to(posts_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        delete :destroy, params: { id: post_item.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
