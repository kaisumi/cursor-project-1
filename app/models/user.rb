class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [ :email ]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :encrypted_password, presence: true

  # Remove the default password requirement
  def password_required?
    false
  end

  # Override devise's password validation
  def email_required?
    true
  end

  def will_save_change_to_email?
    false
  end

  def avatar_url
    avatar.attached? ? avatar : nil
  end
end
