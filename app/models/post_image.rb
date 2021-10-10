class PostImage < ApplicationRecord

  belongs_to :user
  attachment :image
  has_many :comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

  has_many :post_image_tags,dependent: :destroy
  has_many :tags,through: :post_image_tags

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def save_tags(tag_list)

    #全て消す
    post_image_tags.destroy_all
    #まだ未登録のtagを追加
    tag_list.each do |tag|

       find_tag = Tag.find_by(name: tag.downcase)
       # dbに同じtagがあるか.なければ追加 かつpost_image_tagも作成

      unless find_tag

        tags.create!(name: tag)

      else
        post_image_tags.create!(tag_id: find_tag.id)
      end

    end
  end
end

