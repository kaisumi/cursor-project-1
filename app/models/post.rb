class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 10000 }
  validates :user_id, presence: true

  def editable_by?(user)
    return false if user.nil?
    self.user_id == user.id
  end

  def liked_by?(user)
    return false if user.nil?
    likes.exists?(user_id: user.id)
  end
end
