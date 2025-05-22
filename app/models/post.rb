class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  
  validates :content, presence: true, length: { maximum: 280 }
  validates :user_id, presence: true
  
  default_scope -> { order(created_at: :desc) }
  
  # Full-text search
  def self.search(query)
    if query.present?
      where("tsv @@ plainto_tsquery('english', ?)", query)
        .order("ts_rank(tsv, plainto_tsquery('english', #{sanitize(query)})) DESC")
    else
      none
    end
  end
end
