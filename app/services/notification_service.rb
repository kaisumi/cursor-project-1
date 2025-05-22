class NotificationService
  def self.create(user, notifiable, action)
    notification = user.notifications.create(
      notifiable: notifiable,
      action: action
    )
    
    return unless notification.persisted?
    
    # Broadcast notification via ActionCable
    ActionCable.server.broadcast(
      "notifications_#{user.id}",
      { 
        notification: ApplicationController.render(
          partial: 'notifications/notification',
          locals: { notification: notification }
        )
      }
    )
    
    notification
  end
  
  def self.mark_as_read(notification)
    notification.mark_as_read!
  end
  
  def self.mark_all_as_read(user)
    user.notifications.unread.update_all(read: true)
  end
end
