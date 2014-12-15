module LineItemsHelper
  def add_to_cart_tag(product, class_name = "btn btn-sm btn-success")
    return "" if product.blank?
    
    html = <<-HTML
      <div class="btn-wrapper">
        <a onclick="App.addToCart(this)" data-product-id="#{product.id}" class="#{class_name}" id="item-#{product.id}">加入购物车</a>
        <div id="result-#{product.id}" class="add-to-cart-result"></div>
      </div>
      
    HTML
    
    html.html_safe
  end
  
  def render_item_quantity(item)
    return "" if item.blank?
    html = <<-HTML
      <span class="quantity-ctrl">
        <a onclick="App.reduceQuantity(this)" class="reduce" data-id="#{item.id}" id="reduce-#{item.id}" disabled>&#65293;</a>
        <span class="quantity" id="line_item_quantity_#{item.id}" data-quantity="#{item.quantity}">#{item.quantity}</span>
        <a onclick="App.increaseQuantity(this)" class="increase" data-id="#{item.id}" id="increase-#{item.id}">+</a>
      </span>
    HTML
    
    html.html_safe
  end
end
