class AddAreaIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :area_id, :integer
    add_index :orders, :area_id
  end
end
