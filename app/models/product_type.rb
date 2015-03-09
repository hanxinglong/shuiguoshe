class ProductType < ActiveRecord::Base
  
  belongs_to :area
  
  has_many :products, dependent: :destroy, foreign_key: "type_id"
  has_many :hot_products, -> { saled.order('sort ASC, orders_count DESC, id DESC').limit(4) }, class_name: "Product", foreign_key: "type_id"
  
  validates :name, :area_id, presence: true
  
  scope :sorted, -> { order('sort ASC, id ASC') }
  
  def self.all_types
    @product_types = ProductType.where(area_id: 1).order('sort ASC, id ASC')
  end
  
  def area_info
    if area.blank?
      ""
    else
      "#{area.name}（#{area.address}）"
    end
  end
  
  def area_type_name
    if area.blank?
      self.name
    else
      "#{area.name}—#{self.name}"
    end
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
    }
  end
  
end

# == Schema Information
#
# Table name: product_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
