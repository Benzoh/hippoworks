class ChangeColumnToCommentRecipient < ActiveRecord::Migration[5.2]
  def change
    change_column :comment_recipients, :is_read, :boolean, default: false
  end
end
