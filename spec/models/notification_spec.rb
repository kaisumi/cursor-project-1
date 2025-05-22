require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  
  it "is valid with valid attributes" do
    notification = Notification.new(
      user: user,
      notifiable: post,
      action: "like"
    )
    expect(notification).to be_valid
  end
  
  it "is not valid without an action" do
    notification = Notification.new(
      user: user,
      notifiable: post,
      action: nil
    )
    expect(notification).not_to be_valid
  end
  
  it "is not valid without a user" do
    notification = Notification.new(
      user: nil,
      notifiable: post,
      action: "like"
    )
    expect(notification).not_to be_valid
  end
  
  it "is not valid without a notifiable object" do
    notification = Notification.new(
      user: user,
      notifiable: nil,
      action: "like"
    )
    expect(notification).not_to be_valid
  end
  
  it "can be marked as read" do
    notification = Notification.create(
      user: user,
      notifiable: post,
      action: "like"
    )
    expect(notification.read).to be_falsey
    
    notification.mark_as_read!
    expect(notification.reload.read).to be_truthy
  end
  
  describe "scopes" do
    before do
      @read_notification = Notification.create(
        user: user,
        notifiable: post,
        action: "like",
        read: true
      )
      
      @unread_notification = Notification.create(
        user: user,
        notifiable: post,
        action: "follow",
        read: false
      )
    end
    
    it "returns unread notifications with unread scope" do
      expect(Notification.unread).to include(@unread_notification)
      expect(Notification.unread).not_to include(@read_notification)
    end
    
    it "returns recent notifications with recent scope" do
      expect(Notification.recent).to include(@unread_notification, @read_notification)
    end
  end
end
