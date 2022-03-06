class CreateLikeNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :like_notifications do |t|
      t.integer :user_id
      t.string :parent_type
      t.integer :parent_id
      t.boolean :is_read

      t.timestamps
    end
  end
end
