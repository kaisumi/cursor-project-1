class AuthMailer < ApplicationMailer
  def login_link(user, token)
    @user = user
    @token = token
    @url = "#{root_url}auth/verify?token=#{token}"
    
    mail(to: @user.email, subject: "【SNSアプリ】ログインリンク")
  end
end
