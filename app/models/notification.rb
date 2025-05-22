class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  validates :action, presence: true
  
  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(15) }
  
  def mark_as_read!
    update(read: true)
  end
end
