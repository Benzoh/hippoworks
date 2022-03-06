class AddColumnToCalendar20181213800 < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :updated_account_id, :integer
  end
end
