class ChangeTablesColumn < ActiveRecord::Migration
  def change
    remove_index :product_types, :area_id
    remove_column :product_types, :area_id
    add_column :product_types, :seller_id, :integer
    add_index :product_types, :seller_id
  end
end
