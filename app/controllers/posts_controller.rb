class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_correct_user, only: [ :edit, :update, :destroy ]

  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "\u6295\u7A3F\u3092\u4F5C\u6210\u3057\u307E\u3057\u305F"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "\u6295\u7A3F\u3092\u66F4\u65B0\u3057\u307E\u3057\u305F"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "\u6295\u7A3F\u3092\u524A\u9664\u3057\u307E\u3057\u305F"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path, alert: "\u6A29\u9650\u304C\u3042\u308A\u307E\u305B\u3093"
    end
  end
end
