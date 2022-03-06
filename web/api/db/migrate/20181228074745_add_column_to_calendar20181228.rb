class AddColumnToCalendar20181228 < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :current_comment_index_id, :integer, default: 1
  end
end
