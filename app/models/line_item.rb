class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart, inverse_of: :line_items,  touch: true
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

# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  cart_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  quantity   :integer          default(1)
#  order_id   :integer
#
