class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if logged_in?
      # Get posts from followed users and own posts
      following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
      @feed_items = Post.includes(:user, :likes)
                       .where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: current_user.id)
                       .page(params[:page]).per(10)
    end
  end
end
