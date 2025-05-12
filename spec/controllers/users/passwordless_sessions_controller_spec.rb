require 'rails_helper'

RSpec.describe Users::PasswordlessSessionsController, type: :controller do
  let(:user) { create(:user, email: 'test@example.com') }

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid email' do
      before do
        allow(UserPasswordlessMailer).to receive(:magic_link).and_return(double(deliver_later: true))
      end

      it 'sends magic link email' do
        post :create, params: { email: user.email }
        expect(UserPasswordlessMailer).to have_received(:magic_link)
        expect(flash[:notice]).to eq('ログインリンクをメールで送信しました。')
        expect(response).to redirect_to(new_users_passwordless_session_path)
      end
    end

    context 'with invalid email' do
      it 'renders new with error' do
        post :create, params: { email: 'invalid@example.com' }
        expect(flash[:alert]).to eq('メールアドレスが見つかりません。')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    context 'with valid token' do
      before do
        user.update(
          reset_password_token: 'valid_token',
          reset_password_sent_at: Time.current
        )
      end

      it 'signs in user and redirects to root' do
        get :show, params: { token: 'valid_token' }
        expect(controller.current_user).to eq(user)
        expect(flash[:notice]).to eq('ログインしました。')
        expect(response).to redirect_to(root_path)
      end

      it 'clears reset password token' do
        get :show, params: { token: 'valid_token' }
        user.reload
        expect(user.reset_password_token).to be_nil
        expect(user.reset_password_sent_at).to be_nil
      end
    end

    context 'with expired token' do
      before do
        user.update(
          reset_password_token: 'expired_token',
          reset_password_sent_at: 31.minutes.ago
        )
      end

      it 'redirects to new with error' do
        get :show, params: { token: 'expired_token' }
        expect(flash[:alert]).to eq('無効または期限切れのリンクです。')
        expect(response).to redirect_to(new_users_passwordless_session_path)
      end
    end

    context 'with invalid token' do
      it 'redirects to new with error' do
        get :show, params: { token: 'invalid_token' }
        expect(flash[:alert]).to eq('無効または期限切れのリンクです。')
        expect(response).to redirect_to(new_users_passwordless_session_path)
      end
    end
  end
end
