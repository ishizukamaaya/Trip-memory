class AddUserIdToPostImageTags < ActiveRecord::Migration[5.2]
  def change
    add_column :post_image_tags, :user_id, :integer
  end
end
