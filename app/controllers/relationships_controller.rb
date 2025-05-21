class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # フォローする
  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user, notice: 'ユーザーをフォローしました。' }
      format.json { render json: { status: 'success', message: 'フォローしました。' } }
    end
  end

  # フォローを解除する
  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user, notice: 'フォローを解除しました。' }
      format.json { render json: { status: 'success', message: 'フォローを解除しました。' } }
    end
  end

  private

  def set_user
    @user = User.find(params[:followed_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to users_path, alert: 'ユーザーが見つかりません。' }
      format.json { render json: { status: 'error', message: 'ユーザーが見つかりません。' }, status: :not_found }
    end
  end
end
