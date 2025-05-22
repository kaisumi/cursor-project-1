class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  
  validates :content, presence: true, length: { maximum: 280 }
  validates :user_id, presence: true
  
  default_scope -> { order(created_at: :desc) }
end
