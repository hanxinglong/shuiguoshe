class CreateUserDefaultDeliverInfos < ActiveRecord::Migration
  def change
    create_table :user_default_deliver_infos do |t|
      t.integer :user_id
      t.integer :area_id
      t.integer :current_deliver_info_id

      t.timestamps
    end
    add_index :user_default_deliver_infos, :user_id
    add_index :user_default_deliver_infos, :area_id
    add_index :user_default_deliver_infos, :current_deliver_info_id
  end
end
