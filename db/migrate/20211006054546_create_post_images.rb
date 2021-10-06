class CreatePostImages < ActiveRecord::Migration[5.2]
  def change
    create_table :post_images do |t|
      t.string :image_id
      t.string :title
      t.text :introduction
      t.float :evaluation
      t.integer :user_id

      t.timestamps
    end
  end
end
