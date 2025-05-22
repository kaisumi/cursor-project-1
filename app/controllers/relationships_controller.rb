class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  before_action :check_self_follow, only: [:create]

  # フォローする
  def create
    @relationship = current_user.active_relationships.build(followed_id: @user.id)
    
    respond_to do |format|
      if @relationship.save
        format.html { redirect_to @user, notice: 'ユーザーをフォローしました。' }
        format.turbo_stream { render :create }
        format.json { render json: { status: 'success', message: 'フォローしました。' }, status: :ok }
      else
        format.html { redirect_to @user, alert: 'フォローに失敗しました。' }
        format.turbo_stream { render :create, status: :unprocessable_entity }
        format.json { render json: { status: 'error', message: @relationship.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # フォローを解除する
  def destroy
    set_user
    @relationship = current_user.active_relationships.find_by(followed_id: @user.id)
    
    if @relationship.nil?
      respond_to do |format|
        format.html { redirect_to @user, alert: 'フォロー関係が見つかりません。' }
        format.turbo_stream { render :destroy, status: :not_found }
        format.json { render json: { status: 'error', message: 'フォロー関係が見つかりません。' }, status: :not_found }
      end
      return
    end
    
    @relationship.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'フォローを解除しました。' }
      format.turbo_stream { render :destroy }
      format.json { render json: { status: 'success', message: 'フォローを解除しました。' }, status: :ok }
    end
  end

  private

  def set_user
    @user = User.find(params[:followed_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'ユーザーが見つかりません。' }
      format.json { render json: { error: 'ユーザーが見つかりません。' }, status: :not_found }
    end
  end

  # 自分自身をフォローできないようにする
  def check_self_follow
    return unless current_user == @user
    
    respond_to do |format|
      format.html { redirect_to @user, alert: '自分自身をフォローすることはできません。' }
      format.turbo_stream { render :self_follow_error, status: :unprocessable_entity }
      format.json { render json: { error: '自分自身をフォローすることはできません。' }, status: :unprocessable_entity }
    end
  end
  
  # Turbo Stream用のレスポンスを処理
  def render_turbo_stream(action)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@user, :follow_button),
          partial: 'users/follow_button',
          locals: { user: @user }
        )
      end
    end
  end
end
