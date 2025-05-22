class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login, :verify]

  def login
    user = User.find_by(email: params[:email])
    
    if user
      # Generate login token
      token = generate_token(user)
      
      # Send login email
      AuthMailer.login_link(user, token).deliver_now
      
      redirect_to root_path, notice: "ログインリンクを送信しました。メールをご確認ください。"
    else
      # Create new user if not exists
      user = User.new(email: params[:email])
      
      if user.save
        # Generate login token
        token = generate_token(user)
        
        # Send login email
        AuthMailer.login_link(user, token).deliver_now
        
        redirect_to root_path, notice: "アカウントを作成し、ログインリンクを送信しました。メールをご確認ください。"
      else
        redirect_to root_path, alert: "アカウントの作成に失敗しました。"
      end
    end
  end

  def verify
    token = params[:token]
    
    if token.present?
      payload = decode_token(token)
      
      if payload && payload['user_id']
        user = User.find_by(id: payload['user_id'])
        
        if user
          # Set session
          session[:user_id] = user.id
          
          redirect_to root_path, notice: "ログインしました。"
        else
          redirect_to root_path, alert: "無効なトークンです。"
        end
      else
        redirect_to root_path, alert: "無効なトークンです。"
      end
    else
      redirect_to root_path, alert: "トークンが見つかりません。"
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to root_path, notice: "ログアウトしました。"
  end

  private

  def generate_token(user)
    payload = {
      user_id: user.id,
      exp: 30.minutes.from_now.to_i
    }
    
    JWT.encode(payload, ENV.fetch('JWT_SECRET') { 'development_secret' }, 'HS256')
  end

  def decode_token(token)
    begin
      JWT.decode(token, ENV.fetch('JWT_SECRET') { 'development_secret' }, true, algorithm: 'HS256')[0]
    rescue JWT::DecodeError
      nil
    end
  end
end
