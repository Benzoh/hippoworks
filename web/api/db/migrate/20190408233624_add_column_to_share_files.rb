class AddColumnToShareFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :share_files, :comment, :text
  end
end
