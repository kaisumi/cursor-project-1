class Relationship < ApplicationRecord
  # 関連付け
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  # バリデーション
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validate :cannot_follow_self

  private

  # 自分自身をフォローできないようにする
  def cannot_follow_self
    errors.add(:followed_id, "can't follow yourself") if follower_id == followed_id
  end
end
