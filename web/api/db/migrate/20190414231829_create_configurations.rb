class CreateConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :configurations do |t|
      t.string :group_name
      # t.string :icon_img_name
      t.integer :create_user
      t.integer :invite_role_id
      # t.integer :member_count
      # t.integer :storage_volume
      t.text :message_for_members

      t.integer :design_id

      t.integer :mail_display_setting_id

      # t.integer :event_menu_id

      # t.integer :facility_id

      # t.integer :task_status_id

      t.timestamps
    end
  end
end
