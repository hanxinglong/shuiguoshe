# coding: utf-8
class Order < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :product, touch: true
  belongs_to :apartment, touch: true
  
  validates :quantity, :apartment_id, :deliver_time, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1.0 }
  
  before_create :create_order_no
  def create_order_no
    self.order_no = Time.now.to_s(:number) + Time.now.nsec.to_s
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
    self.quantity * product.origin_price
  end
  
  def self.search(keyword)
      joins(:user, :product).where('orders.order_no like :keyword or users.mobile like :keyword or orders.deliver_address like :keyword or products.title like :keyword',{ keyword: "%#{keyword}%"})
  end
  
end
