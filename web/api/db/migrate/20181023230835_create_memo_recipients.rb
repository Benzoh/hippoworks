class CreateMemoRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :memo_recipient do |t|
      t.boolean :is_read, null: false, default: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
