# coding: utf-8
class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  has_many :orders
  
  scope :saled, -> { where(on_sale: true) }
  scope :search, -> keyword { where('title like :keyword or subtitle like :keyword or intro like :keyword', { keyword: "%#{keyword}%" }) }
  
  validates :title, :image, :low_price, :type_id, :origin_price, presence: true
  validates :low_price, :origin_price, format: { with: /\A\d+\.\d{1,}\z/, message: "不正确的价格" }
  
  validate :origin_price_greater_than_low_price
  def origin_price_greater_than_low_price
    if low_price >= origin_price
      errors.add(:low_price, "必须小于初始价格")
    end
  end
  
end
