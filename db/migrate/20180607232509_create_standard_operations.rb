class CreateStandardOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :standard_operations do |t|
      t.string :task
      t.integer :project_id

      t.timestamps
    end
  end
end
