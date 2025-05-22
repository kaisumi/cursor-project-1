class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id }
  
  after_create :create_like_notification
  
  private
  
  def create_like_notification
    # Don't create notification if user likes their own post
    return if user_id == post.user_id
    
    notification = Notification.create(
      user: post.user,
      notifiable: self,
      action: "like"
    )
    
    ActionCable.server.broadcast(
      "notifications_#{post.user_id}",
      { 
        notification: notification, 
        count: post.user.notifications.unread.count,
        message: "#{user.name}があなたの投稿にいいねしました"
      }
    )
  end
end
