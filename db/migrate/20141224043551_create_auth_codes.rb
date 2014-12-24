class CreateAuthCodes < ActiveRecord::Migration
  def change
    create_table :auth_codes do |t|
      t.string :code
      t.string :mobile
      t.boolean :verified, default: true

      t.timestamps
    end
    add_index :auth_codes, :code, unique: true
    add_index :auth_codes, :mobile, unique: true
  end
end
