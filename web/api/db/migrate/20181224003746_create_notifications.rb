class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :thread_type, null: false
      t.integer :thread_id, null: false
      t.integer :user_id, null: false
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end
