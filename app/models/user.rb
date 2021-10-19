class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post_images, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_image_tags, dependent: :destroy
  has_many :tags, through: :post_image_tags, dependent: :destroy
  #フォロー関連ひとまとまり
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #フォローされてる人を取得
  has_many :followers, through: :reverse_of_relationships, source: :follower #自分をフォローしてる人
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #フォローしてる人を取得
  has_many :followings, through: :relationships, source: :followed #自分がフォローしてる人
  #フォロー関連ここまで

  attachment :profile_image

  #バリデーション
  validates :name, length: { maximum: 10, minimum: 2 }, uniqueness: true
  validates :introduction, length: { maximum: 20 }

  #userをfollowする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  #userのfollowを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #follow確認する
  def following?(user)
    followings.include?(user)
  end

end
