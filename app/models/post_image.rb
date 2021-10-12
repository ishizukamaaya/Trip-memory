class PostImage < ApplicationRecord

  belongs_to :user
  attachment :image
  has_many :comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

  has_many :post_image_tags,dependent: :destroy
  has_many :tags,through: :post_image_tags

  #バリデーション
  validates :image, presence: true
  validates :title, presence: true,length: {maximum: 10}
  validates :introduction, presence: true,length: {maximum: 50}
  validates :evaluation, presence: true

  #検索機能ヘッダー
  def self.search(search_word)
      PostImage.where(["title LIKE(?) OR introduction LIKE(?)", "#{search_word}","#{search_word}"])
  end

  #tag関連
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

