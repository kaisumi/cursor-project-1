class Users::PasswordlessSessionsController < ApplicationController
  def new
    # メールアドレス入力フォーム表示
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      token = SecureRandom.urlsafe_base64(32)
      user.update_column(:reset_password_token, token)
      user.update_column(:reset_password_sent_at, Time.current)
      UserPasswordlessMailer.magic_link(user, token).deliver_later
      flash[:notice] = "\u30ED\u30B0\u30A4\u30F3\u30EA\u30F3\u30AF\u3092\u30E1\u30FC\u30EB\u3067\u9001\u4FE1\u3057\u307E\u3057\u305F\u3002"
      redirect_to new_users_passwordless_session_path
    else
      flash[:alert] = "\u30E1\u30FC\u30EB\u30A2\u30C9\u30EC\u30B9\u304C\u898B\u3064\u304B\u308A\u307E\u305B\u3093\u3002"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(reset_password_token: params[:token])
    if user && user.reset_password_sent_at > 30.minutes.ago
      sign_in(user)
      user.update_column(:reset_password_token, nil)
      user.update_column(:reset_password_sent_at, nil)
      flash[:notice] = "\u30ED\u30B0\u30A4\u30F3\u3057\u307E\u3057\u305F\u3002"
      redirect_to root_path
    else
      flash[:alert] = "\u7121\u52B9\u307E\u305F\u306F\u671F\u9650\u5207\u308C\u306E\u30EA\u30F3\u30AF\u3067\u3059\u3002"
      redirect_to new_users_passwordless_session_path
    end
  end
end
