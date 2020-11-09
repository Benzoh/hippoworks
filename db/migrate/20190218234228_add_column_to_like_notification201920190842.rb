class AddColumnToLikeNotification201920190842 < ActiveRecord::Migration[5.2]
  def change
    add_column :like_notifications, :thread_type, :string
    add_column :like_notifications, :thread_id, :integer
  end
end
