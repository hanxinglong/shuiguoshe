class AddIsSellerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_seller, :boolean, default: false
  end
end
