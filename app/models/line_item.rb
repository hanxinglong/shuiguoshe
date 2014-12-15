class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :order
  
  def total_price
    product.low_price * quantity
  end
  
  def update_sales_count
    product.orders_count += self.quantity
    product.save
  end
  
end
