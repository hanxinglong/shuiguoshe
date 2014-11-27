# coding: utf-8
class Order < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :product
  
  validates :quantity, :deliver_address, :deliver_time, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 1.0 }
  
  before_create :create_order_no
  def create_order_no
    self.order_no = Time.now.to_s(:number) + Time.now.nsec.to_s
  end
  
  def self.today_count
    where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).count
  end
  
end
