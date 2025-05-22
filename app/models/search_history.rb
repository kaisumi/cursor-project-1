class SearchHistory < ApplicationRecord
  belongs_to :user
  
  validates :query, presence: true
  
  scope :recent, -> { order(created_at: :desc).limit(10) }
  
  def self.popular
    group(:query).order('count_id DESC').limit(10).count(:id)
  end
end
