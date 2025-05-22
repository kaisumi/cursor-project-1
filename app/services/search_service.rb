class SearchService
  def self.search_posts(query, page = 1, per_page = 20)
    return Post.none if query.blank?
    
    Post.search(query)
      .includes(:user)
      .page(page)
      .per(per_page)
  end
  
  def self.search_users(query, page = 1, per_page = 20)
    return User.none if query.blank?
    
    User.where("name ILIKE ?", "%#{query}%")
      .page(page)
      .per(per_page)
  end
  
  def self.save_search_history(user, query)
    user.search_histories.create(query: query) if query.present?
  end
  
  def self.popular_searches(limit = 10)
    SearchHistory.popular
  end
  
  def self.recent_searches(user, limit = 10)
    user.search_histories.recent
  end
end
