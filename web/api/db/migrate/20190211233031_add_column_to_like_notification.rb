class AddColumnToLikeNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :like_notifications, :from_user_id, :integer
  end
end
