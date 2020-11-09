class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.string :thread_type
      t.integer :thread_id

      t.timestamps
    end
  end
end
