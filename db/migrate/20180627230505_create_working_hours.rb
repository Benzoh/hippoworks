class CreateWorkingHours < ActiveRecord::Migration[5.2]
  def change
    create_table :working_hours do |t|
      t.integer :secs
      t.integer :task_id
      t.integer :project_id

      t.timestamps
    end
  end
end
