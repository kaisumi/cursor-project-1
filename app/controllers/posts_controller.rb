class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:user).page(params[:page]).per(20)
  end
  
  def show
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def edit
    redirect_to root_path, alert: "自分の投稿のみ編集できます" unless @post.user == current_user
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: "投稿が作成されました"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    if @post.user != current_user
      redirect_to root_path, alert: "自分の投稿のみ編集できます"
      return
    end
    
    if @post.update(post_params)
      redirect_to @post, notice: "投稿が更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @post.user != current_user
      redirect_to root_path, alert: "自分の投稿のみ削除できます"
      return
    end
    
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:content)
  end
end
