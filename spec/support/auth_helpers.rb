module AuthHelpers
  # パスワードレス認証用のヘルパーメソッド
  def login_as(user)
    token = user.generate_passwordless_token!
    get "/users/sign_in/#{token}"
  end

  # ログアウト用のヘルパーメソッド
  def logout
    delete "/users/sign_out"
  end

  # 現在のユーザーを取得するヘルパーメソッド
  def current_user
    controller.current_user
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :controller
end
