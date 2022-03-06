class AddStateToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :state, :boolean
  end
end
