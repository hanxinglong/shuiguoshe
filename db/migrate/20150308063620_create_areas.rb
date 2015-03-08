class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :address
      t.boolean :visible, default: true
      t.integer :sort, default: 0 # 显示顺序, 值越小越靠前

      t.timestamps
    end
  end
end
