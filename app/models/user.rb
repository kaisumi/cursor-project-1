class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  # Follow relationships
  has_many :active_relationships, class_name: "Relationship",
                                 foreign_key: "follower_id",
                                 dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, length: { maximum: 50 }
  
  # Follow another user
  def follow(other_user)
    following << other_user unless self == other_user
  end
  
  # Unfollow a user
  def unfollow(other_user)
    following.delete(other_user)
  end
  
  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end
end
