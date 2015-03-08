class CreateAreasBanners < ActiveRecord::Migration
  def change
    create_table :areas_banners, id: false do |t|
      t.integer :area_id
      t.integer :banner_id
    end
    
  end
end
