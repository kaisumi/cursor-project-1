require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: post.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    context 'ログインしている場合' do
      before { sign_in user }

      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログインしていない場合' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      before { sign_in user }

      context '有効なパラメータの場合' do
        let(:valid_params) { { post: { title: 'Test Post', content: 'Test Content' } } }

        it 'creates a new post' do
          expect {
            post :create, params: valid_params
          }.to change(Post, :count).by(1)
        end

        it 'redirects to the created post' do
          post :create, params: valid_params
          expect(response).to redirect_to(post_path(Post.last))
        end
      end

      context '無効なパラメータの場合' do
        let(:invalid_params) { { post: { title: '', content: '' } } }

        it 'does not create a new post' do
          expect {
            post :create, params: invalid_params
          }.not_to change(Post, :count)
        end

        it 'renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'redirects to sign in page' do
        post :create, params: { post: { title: 'Test Post', content: 'Test Content' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before { sign_in user }

        it 'returns http success' do
          get :edit, params: { id: post.id }
          expect(response).to have_http_status(:success)
        end
      end

      context '投稿の作成者でない場合' do
        before { sign_in other_user }

        it 'redirects to root path' do
          get :edit, params: { id: post.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'redirects to sign in page' do
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before { sign_in user }

        context '有効なパラメータの場合' do
          let(:valid_params) { { id: post.id, post: { title: 'Updated Title', content: 'Updated Content' } } }

          it 'updates the post' do
            patch :update, params: valid_params
            post.reload
            expect(post.title).to eq('Updated Title')
            expect(post.content).to eq('Updated Content')
          end

          it 'redirects to the updated post' do
            patch :update, params: valid_params
            expect(response).to redirect_to(post_path(post))
          end
        end

        context '無効なパラメータの場合' do
          let(:invalid_params) { { id: post.id, post: { title: '', content: '' } } }

          it 'does not update the post' do
            original_title = post.title
            original_content = post.content
            patch :update, params: invalid_params
            post.reload
            expect(post.title).to eq(original_title)
            expect(post.content).to eq(original_content)
          end

          it 'renders the edit template' do
            patch :update, params: invalid_params
            expect(response).to render_template(:edit)
          end
        end
      end

      context '投稿の作成者でない場合' do
        before { sign_in other_user }

        it 'redirects to root path' do
          patch :update, params: { id: post.id, post: { title: 'Updated Title', content: 'Updated Content' } }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'redirects to sign in page' do
        patch :update, params: { id: post.id, post: { title: 'Updated Title', content: 'Updated Content' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      context '投稿の作成者の場合' do
        before { sign_in user }

        it 'deletes the post' do
          expect {
            delete :destroy, params: { id: post.id }
          }.to change(Post, :count).by(-1)
        end

        it 'redirects to posts index' do
          delete :destroy, params: { id: post.id }
          expect(response).to redirect_to(posts_path)
        end
      end

      context '投稿の作成者でない場合' do
        before { sign_in other_user }

        it 'does not delete the post' do
          expect {
            delete :destroy, params: { id: post.id }
          }.not_to change(Post, :count)
        end

        it 'redirects to root path' do
          delete :destroy, params: { id: post.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'redirects to sign in page' do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
