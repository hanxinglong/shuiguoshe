class AddNameAndAreaIdToDeliverInfos < ActiveRecord::Migration
  def change
    add_column :deliver_infos, :name, :string
    add_column :deliver_infos, :area_id, :integer
  end
end
