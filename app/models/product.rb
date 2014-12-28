# coding: utf-8

class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  has_many :orders
  has_many :line_items
  belongs_to :sale
  
  scope :saled, -> { where(on_sale: true) }
  scope :search, -> keyword { where('title like :keyword or subtitle like :keyword or intro like :keyword', { keyword: "%#{keyword}%" }) }
  
  scope :suggest, -> { where.not(suggested_at: nil).order('suggested_at desc') }
  scope :hot, -> { where('orders_count > 0').order('orders_count desc').limit(5) }
  scope :no_discount, -> { where(is_discount: false) }
  scope :discounted, -> { where('is_discount = ? and discounted_at > ?', true, Time.now).limit(3) }
  
  validates :title, :image, :low_price, :type_id, :origin_price, :units, presence: true
  
  validates :low_price, :origin_price, format: { with: /\A\d+\.\d{1,}\z/, message: "不正确的价格" }
  validates :low_price, :origin_price, numericality: { greater_than: 0 }
  
  validates :discount_score, :stock_count, format: { with: /\d+/, message: "必须是整数" }
  validates :discount_score, :stock_count, numericality: { greater_than_or_equal_to: 0 }
  
  validates :discounted_at, presence: true, if: Proc.new { |a| a[:is_discount] }#:required_discount?
  
  validate :origin_price_greater_than_low_price
  def origin_price_greater_than_low_price
    if low_price >= origin_price
      errors.add(:low_price, "必须小于市场价格")
    end
  end
  
  before_destroy :ensure_not_referenced_by_any_line_item
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, '改产品已经被添加到了购物车，不能被删除')
      return false
    end
  end
  
  def required_discount?
    self.is_discount
  end
  
  def add_order_count
    self.class.increment_counter(:orders_count, self.id)
  end
  
  def suggested?
    self.suggested_at.present?
  end
  
  def as_json(options)
    json = {
      id: self.id,
      title: self.title || "",
      subtitle: self.subtitle || "",
      intro: self.intro || "",
      thumb_image: thumb_image_url,
      low_price: format("%.2f", self.low_price),
      origin_price: format("%.2f", self.origin_price),
      unit: self.units || "",
      orders_count: self.orders_count,
    }
    json[:discounted_at] = self.discounted_at.strftime("%Y-%m-%d %H:%M:%S") if self.discounted_at
    json
  end
  
  def delivered_time
    if self.delivered_at
      self.delivered_at.strftime("%Y-%m-%d %H:%M:%S")
    else
      ""
    end
  end
  
  def thumb_image_url
    if self.image
      self.image.url(:thumb) || ""
    else
      ""
    end
  end
  
  def large_image_url
    if self.image
      self.image.url(:large) || ""
    else
      ""
    end
  end
  
end

# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  type_id        :integer
#  title          :string(255)
#  intro          :string(255)
#  image          :string(255)
#  low_price      :decimal(8, 2)    default(0.0)
#  origin_price   :decimal(8, 2)    default(0.0)
#  created_at     :datetime
#  updated_at     :datetime
#  subtitle       :string(255)
#  on_sale        :boolean          default(TRUE)
#  orders_count   :integer          default(0)
#  suggested_at   :datetime
#  units          :string(255)
#  note           :string(255)
#  is_discount    :boolean          default(FALSE)
#  discounted_at  :datetime
#  discount_score :integer          default(0)
#  delivered_at   :datetime
#  stock_count    :integer          default(10000)
#  sale_id        :integer
#
