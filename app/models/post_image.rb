class PostImage < ApplicationRecord

  belongs_to :user
  attachment :image
  has_many :comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id,post_image_id: self.id).exists?
  end

end
