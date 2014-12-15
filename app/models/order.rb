# coding: utf-8
class Order < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :apartment, touch: true
  
  has_many :line_items, dependent: :destroy
  
  validates :apartment_id, :total_price, presence: true
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }, 
            :presence => true
            
  # validates :apartment_id, inclusion: { in: Apartment.opened.map { |a| [a.id] }, message: "%{value} 不是一个有效的值" }
  
  before_create :create_order_no
  def create_order_no
    self.order_no = Time.now.to_s(:number) + Time.now.nsec.to_s
  end
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  
  # def apartment
  #   @apartment ||= Apartment.find_by_id(self.apartment_id).try(:name)
  # end
  
  def update_orders_count
    line_items.each do |item|
      item.update_sales_count
    end
  end
  
  def self.today_count
    self.today.count
  end
  
  state_machine initial: :normal do
    state :canceled
    state :completed
    
    event :cancel do
      transition :normal => :canceled
    end
    
    event :complete do
      transition :normal => :completed
    end
  end
  
  scope :today, -> { where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  scope :normal, -> { with_state(:normal) }
  scope :canceled, -> { with_state(:canceled) }
  scope :completed, -> { with_state(:completed) }
  
  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
  
  def self.search(keyword)
    if keyword.gsub(/\s+/, "").present?
      joins(:user, :product).where('orders.order_no like :keyword or users.mobile like :keyword or orders.deliver_address like :keyword or products.title like :keyword',{ keyword: "%#{keyword}%"})
    else
      all
    end
      
  end
  
end
