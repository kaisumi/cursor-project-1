require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_item) { create(:post, user: user) }

  describe 'GET #index' do
    before { get :index }

    it '正常にレスポンスを返すこと' do
      expect(response).to have_http_status(:success)
    end

    it '投稿一覧を取得すること' do
      expect(assigns(:posts)).to eq([ post_item ])
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: post_item.id } }

    it '正常にレスポンスを返すこと' do
      expect(response).to have_http_status(:success)
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
        expect(response).to have_http_status(:success)
      end

      it '新しい投稿を初期化すること' do
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'ログインしていない場合' do
      before { get :new }

      it 'ログインページにリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      before { sign_in user }

      context '有効なパラメータの場合' do
        let(:valid_attributes) { attributes_for(:post) }

        it '投稿を作成すること' do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it '作成した投稿の詳細ページにリダイレクトすること' do
          post :create, params: { post: valid_attributes }
          expect(response).to redirect_to(Post.last)
        end
      end

      context '無効なパラメータの場合' do
        let(:invalid_attributes) { attributes_for(:post, title: '') }

        it '投稿を作成しないこと' do
          expect {
            post :create, params: { post: invalid_attributes }
          }.not_to change(Post, :count)
        end

        it '新規投稿ページを再表示すること' do
          post :create, params: { post: invalid_attributes }
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
      context '投稿の作成者の場合' do
        before do
          sign_in user
          get :edit, params: { id: post_item.id }
        end

        it '正常にレスポンスを返すこと' do
          expect(response).to have_http_status(:success)
        end

        it '編集対象の投稿を取得すること' do
          expect(assigns(:post)).to eq(post_item)
        end
      end

      context '投稿の作成者でない場合' do
        before do
          sign_in other_user
          get :edit, params: { id: post_item.id }
        end

        it '投稿一覧ページにリダイレクトすること' do
          expect(response).to redirect_to(posts_path)
        end

        it '権限エラーメッセージを表示すること' do
          expect(flash[:alert]).to eq('権限がありません')
        end
      end
    end

    context 'ログインしていない場合' do
      before { get :edit, params: { id: post_item.id } }

      it 'ログインページにリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before { sign_in user }

        context '有効なパラメータの場合' do
          let(:new_attributes) { { title: 'Updated Title', content: 'Updated Content' } }

          it '投稿を更新すること' do
            patch :update, params: { id: post_item.id, post: new_attributes }
            post_item.reload
            expect(post_item.title).to eq('Updated Title')
            expect(post_item.content).to eq('Updated Content')
          end

          it '更新した投稿の詳細ページにリダイレクトすること' do
            patch :update, params: { id: post_item.id, post: new_attributes }
            expect(response).to redirect_to(post_item)
          end
        end

        context '無効なパラメータの場合' do
          let(:invalid_attributes) { { title: '' } }

          it '投稿を更新しないこと' do
            patch :update, params: { id: post_item.id, post: invalid_attributes }
            post_item.reload
            expect(post_item.title).not_to eq('')
          end

          it '編集ページを再表示すること' do
            patch :update, params: { id: post_item.id, post: invalid_attributes }
            expect(response).to render_template(:edit)
          end
        end
      end

      context '投稿の作成者でない場合' do
        before do
          sign_in other_user
          patch :update, params: { id: post_item.id, post: { title: 'New Title' } }
        end

        it '投稿一覧ページにリダイレクトすること' do
          expect(response).to redirect_to(posts_path)
        end

        it '権限エラーメッセージを表示すること' do
          expect(flash[:alert]).to eq('権限がありません')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        patch :update, params: { id: post_item.id, post: { title: 'New Title' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before { sign_in user }

        it '投稿を削除すること' do
          expect {
            delete :destroy, params: { id: post_item.id }
          }.to change(Post, :count).by(-1)
        end

        it '投稿一覧ページにリダイレクトすること' do
          delete :destroy, params: { id: post_item.id }
          expect(response).to redirect_to(posts_path)
        end
      end

      context '投稿の作成者でない場合' do
        before do
          sign_in other_user
          delete :destroy, params: { id: post_item.id }
        end

        it '投稿を削除しないこと' do
          expect {
            delete :destroy, params: { id: post_item.id }
          }.not_to change(Post, :count)
        end

        it '投稿一覧ページにリダイレクトすること' do
          expect(response).to redirect_to(posts_path)
        end

        it '権限エラーメッセージを表示すること' do
          expect(flash[:alert]).to eq('権限がありません')
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
