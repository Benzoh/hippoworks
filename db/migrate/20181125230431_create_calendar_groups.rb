class CreateCalendarGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_groups do |t|
      t.integer :calendar_id
      t.integer :group_id
      t.timestamps
    end
  end
end
