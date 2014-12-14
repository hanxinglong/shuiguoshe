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
end
