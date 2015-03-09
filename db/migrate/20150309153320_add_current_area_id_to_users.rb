class AddCurrentAreaIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_area_id, :integer
    add_index :users, :current_area_id
  end
end
