class AddColumnToCalendar20181209 < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :start_time_epoc, :integer
    add_column :calendars, :end_time_epoc, :integer
  end
end
