class RenameCalendarAccountToEventAccount < ActiveRecord::Migration[5.2]
  def change
    rename_table :calendar_accounts, :event_accounts
  end
end
