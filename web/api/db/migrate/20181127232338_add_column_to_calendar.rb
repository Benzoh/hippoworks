class AddColumnToCalendar < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :end_year, :integer, after: :start_minute
    add_column :calendars, :end_month, :integer, after: :end_year
    add_column :calendars, :end_day, :integer, after: :end_month
    add_column :calendars, :end_hour, :integer, after: :end_day
    add_column :calendars, :end_minute, :integer, after: :end_hour

    remove_columns :calendars, :category, :group_id
  end
end
