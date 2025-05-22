class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @notifications = current_user.notifications.recent
  end
  
  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    NotificationService.mark_as_read(@notification)
    
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.turbo_stream
    end
  end
  
  def mark_all_as_read
    NotificationService.mark_all_as_read(current_user)
    
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.turbo_stream
    end
  end
end
