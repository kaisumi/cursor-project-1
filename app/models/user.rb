class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [ :email ]

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  # フォロー関連のアソシエーション
  has_many :active_relationships, class_name: 'Relationship',
                                foreign_key: 'follower_id',
                                dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                 foreign_key: 'followed_id',
                                 dependent: :destroy
  
  # フォロー/フォロワー関連
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # アバター画像用のアタッチメント
  has_one_attached :avatar

  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    length: { minimum: 3, maximum: 30 },
                    format: { with: /\A[a-zA-Z0-9_]+\z/, message: 'は英数字とアンダースコアのみ使用できます' }
  validates :bio, length: { maximum: 160 }
  validates :encrypted_password, presence: true

  # アバター画像のバリデーション
  validate :avatar_content_type, if: -> { avatar.attached? }
  validate :avatar_size, if: -> { avatar.attached? }
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # ユーザーがフォローされているかどうかを確認
  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def avatar_url
    # 実際のアバター画像の実装がない場合はnilを返す
    nil
  end

  private
  
  def avatar_content_type
    unless avatar.content_type.in?(%w(image/jpeg image/png image/gif))
      errors.add(:avatar, 'はJPEG、PNG、GIF形式のみアップロードできます')
    end
  end
  
  def avatar_size
    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, 'のサイズは5MB以下にしてください')
    end
  end

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
end
