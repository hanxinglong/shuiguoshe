# coding: utf-8
class Order < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :product
  
  validates :quantity, :apartment, presence: true
  validates :quantity, numericality: true#, greater_than_or_equal_to: 1
  
  before_create :create_order_no
  def create_order_no
    self.order_no = Time.now.to_s(:number) + Time.now.nsec.to_s
  end
end
