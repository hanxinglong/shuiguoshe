class AddOrdersCountToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :orders_count, :integer, default: 0
  end
end
