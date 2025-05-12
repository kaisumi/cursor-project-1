class UserPasswordlessMailer < ApplicationMailer
  def magic_link(user, token)
    @user = user
    @token = token
    mail(
      to: @user.email,
      subject: "\u30ED\u30B0\u30A4\u30F3\u30EA\u30F3\u30AF"
    )
  end
end
