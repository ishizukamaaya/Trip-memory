class RemovePostImageIdFromTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :tags, :post_image_id, :integer
  end
end
