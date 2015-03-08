class AddAreaIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :area_id, :integer
    add_index :carts, :area_id
  end
end
