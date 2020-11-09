class AddColumnToProjects201902150821 < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :user_id, :integer
    add_column :calendars, :user_id, :integer
  end
end
