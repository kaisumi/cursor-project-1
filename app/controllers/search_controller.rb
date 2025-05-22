class SearchController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @query = params[:q]
    @posts = Post.search(@query).includes(:user).page(params[:page]).per(20) if @query.present?
    @users = User.where("name ILIKE ?", "%#{@query}%").page(params[:page]).per(20) if @query.present?
    
    # Save search history
    current_user.search_histories.create(query: @query) if @query.present?
    
    # Get popular searches
    @popular_searches = SearchHistory.popular
    
    # Get user's recent searches
    @recent_searches = current_user.search_histories.recent
  end
end
