class AddPaymentTypeAndShipmentTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_type, :integer
    add_index :orders, :payment_type
    add_column :orders, :shipment_type, :integer
    add_index :orders, :shipment_type
  end
end
