class CreateCommentRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_recipients do |t|
      t.bigint :comment_id
      t.boolean :is_read
      t.bigint :user_id

      t.timestamps
    end
  end
end
