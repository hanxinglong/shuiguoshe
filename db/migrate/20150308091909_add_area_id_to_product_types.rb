class AddAreaIdToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :area_id, :integer
    add_index :product_types, :area_id
  end
end
