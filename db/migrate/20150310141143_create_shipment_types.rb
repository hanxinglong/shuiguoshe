class CreateShipmentTypes < ActiveRecord::Migration
  def change
    create_table :shipment_types do |t|
      t.string :name
      t.integer :sort, default: 0

      t.timestamps
    end
  end
end
