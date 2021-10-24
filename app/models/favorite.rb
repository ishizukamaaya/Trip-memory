class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post_image

  default_scope -> { order(created_at: :desc) } #いいねの新しい順

end
