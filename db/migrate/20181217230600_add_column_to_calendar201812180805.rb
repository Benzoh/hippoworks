class AddColumnToCalendar201812180805 < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :slug, :string
  end
end
