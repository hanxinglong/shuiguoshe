class Cart < ActiveRecord::Base
  has_many :line_items, -> { includes(:product) }, dependent: :destroy
  
  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product: product)
    end
    current_item
  end
  
  def add_cart(other_cart)
    if other_cart and other_cart.line_items.any?
      other_cart.line_items.each do |item|
        current_item = line_items.find_by(product_id: item.product.id)
        if current_item
          current_item.quantity += item.quantity
        else
          current_item = line_items.build(product_id: item.product.id, quantity: item.quantity)
        end
        current_item.save
      end
    end
    return true
  end
  
  def total_price
    line_items.to_a.sum { |item| item.total_price }  
  end
  
  def total_items
    line_items.sum(:quantity)
  end
  
end
