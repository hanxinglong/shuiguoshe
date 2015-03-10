class ChangeColumnsForUsers < ActiveRecord::Migration
  def change
    remove_index :users, :current_area_id
    remove_column :users, :current_area_id
    
    remove_column :users, :deliver_time
    remove_column :users, :deliver_address
    
    add_column :users, :shipment_type, :integer, default: 3
    add_column :users, :payment_type, :integer, default: 1
  end
end
