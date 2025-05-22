class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User", counter_cache: :following_count
  belongs_to :followed, class_name: "User", counter_cache: :followers_count
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
  
  after_create :create_follow_notification
  
  private
  
  def create_follow_notification
    notification = Notification.create(
      user: followed,
      notifiable: self,
      action: "follow"
    )
    
    ActionCable.server.broadcast(
      "notifications_#{followed.id}",
      { 
        notification: ApplicationController.render(
          partial: 'notifications/notification',
          locals: { notification: notification }
        ),
        count: followed.notifications.unread.count,
        message: "#{follower.name}があなたをフォローしました"
      }
    )
  end
end
