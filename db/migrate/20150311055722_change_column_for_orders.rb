class ChangeColumnForOrders < ActiveRecord::Migration
  def change
    remove_index :orders, :area_id
    remove_column :orders, :area_id
    
    add_column :orders, :deliver_info_id, :integer
    add_index :orders, :deliver_info_id
  end
end
