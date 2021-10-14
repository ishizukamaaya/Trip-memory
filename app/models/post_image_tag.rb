class PostImageTag < ApplicationRecord

  belongs_to :post_image
  belongs_to :tag
  has_many :users
  #post_imageとtagの関係を構築する際に、2つの外部キーが存在することは絶対なのでバリデーション
  validates :post_image_id, presence: true
  validates :tag_id, presence: true

end
