class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :number
      t.date :delivery_date

      t.timestamps
    end
  end
end
