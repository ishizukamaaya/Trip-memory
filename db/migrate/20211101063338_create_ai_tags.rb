class CreateAiTags < ActiveRecord::Migration[5.2]
  def change
    create_table :ai_tags do |t|
      t.string :name
      t.integer :post_image_id

      t.timestamps
    end
  end
end
