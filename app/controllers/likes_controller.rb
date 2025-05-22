class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "投稿をいいねしました" }
      format.turbo_stream
    end
  end
  
  def destroy
    @like = Like.find(params[:id])
    @post = @like.post
    current_user.unlike(@post)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "いいねを取り消しました" }
      format.turbo_stream
    end
  end
end
