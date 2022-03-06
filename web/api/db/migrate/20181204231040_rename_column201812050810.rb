class RenameColumn201812050810 < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_accounts, :calendar_id, :event_id
  end
end
