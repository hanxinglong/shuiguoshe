class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :order
  
  def total_price
    product.low_price * quantity
  end
  
  def update_sales_count(oper)
    if oper == 1
      product.orders_count += self.quantity
    elsif oper == -1
      product.orders_count -= self.quantity
    end
    product.save
  end
  
end
