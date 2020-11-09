class AddColumnToShareFile < ActiveRecord::Migration[5.2]
  def change
    add_column :share_files, :restore_version, :integer
  end
end
