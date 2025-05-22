require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'POST #login' do
    context 'with existing user' do
      let!(:user) { create(:user) }

      it 'sends login link email' do
        expect {
          post :login, params: { email: user.email }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include('ログインリンクを送信しました')
      end
    end

    context 'with new user' do
      it 'creates a new user and sends login link email' do
        expect {
          post :login, params: { email: 'new@example.com' }
        }.to change { User.count }.by(1)
        .and change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include('アカウントを作成し、ログインリンクを送信しました')
      end
    end
  end

  describe 'GET #verify' do
    let(:user) { create(:user) }
    let(:token) { JWT.encode({ user_id: user.id, exp: 30.minutes.from_now.to_i }, ENV.fetch('JWT_SECRET') { 'development_secret' }, 'HS256') }

    context 'with valid token' do
      it 'logs in the user' do
        get :verify, params: { token: token }

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include('ログインしました')
      end
    end

    context 'with invalid token' do
      it 'does not log in the user' do
        get :verify, params: { token: 'invalid-token' }

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include('無効なトークンです')
      end
    end

    context 'with expired token' do
      it 'does not log in the user' do
        expired_token = JWT.encode({ user_id: user.id, exp: 1.minute.ago.to_i }, ENV.fetch('JWT_SECRET') { 'development_secret' }, 'HS256')
        get :verify, params: { token: expired_token }

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include('無効なトークンです')
      end
    end
  end

  describe 'DELETE #logout' do
    it 'logs out the user' do
      session[:user_id] = create(:user).id
      delete :logout

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include('ログアウトしました')
    end
  end
end
