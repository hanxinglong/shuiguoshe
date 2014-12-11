# coding: utf-8
class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  has_many :orders
  
  scope :saled, -> { where(on_sale: true) }
  scope :search, -> keyword { where('title like :keyword or subtitle like :keyword or intro like :keyword', { keyword: "%#{keyword}%" }) }
  
  scope :suggest, -> { where.not(suggested_at: nil).order('suggested_at desc') }
  scope :hot, -> { where('orders_count > 0').order('orders_count desc').limit(5) }
  
  validates :title, :image, :low_price, :type_id, :origin_price, :units, presence: true
  validates :low_price, :origin_price, format: { with: /\d+/, message: "不正确的价格" }
  validates :low_price, :origin_price, numericality: { greater_than: 0 }
  
  validate :origin_price_greater_than_low_price
  def origin_price_greater_than_low_price
    if low_price >= origin_price
      errors.add(:low_price, "必须小于市场价格")
    end
  end
  
  def add_order_count
    self.class.increment_counter(:orders_count, self.id)
  end
  
  def suggested?
    self.suggested_at.present?
  end
  
end
