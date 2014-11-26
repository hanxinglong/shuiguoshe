# coding: utf-8
class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  validates :title, :image, :low_price, :type_id, :origin_price, presence: true
  
  validates :low_price, :origin_price, format: { with: /\A\d+\.\d{1,}\z/, message: "不正确的价格" }
  
  validate :origin_price_greater_than_low_price
  def origin_price_greater_than_low_price
    if low_price >= origin_price
      errors.add(:low_price, "必须小于初始价格")
    end
  end
  
end
