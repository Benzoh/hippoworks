class CreateTimers < ActiveRecord::Migration[5.2]
  def change
    create_table :timers do |t|
      t.integer :secs
      t.integer :project_id

      t.timestamps
    end
  end
end
