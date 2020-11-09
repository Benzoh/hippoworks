class AddColumnToCabinet < ActiveRecord::Migration[5.2]
  def change
    add_column :cabinets, :group_id, :integer
  end
end
