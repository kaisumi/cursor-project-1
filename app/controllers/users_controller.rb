class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers]

  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  def following
    @title = "フォロー中"
    @users = @user.following.page(params[:page]).per(10)
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @users = @user.followers.page(params[:page]).per(10)
    render 'show_follow'
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'ユーザーが見つかりません。'
  end
end
