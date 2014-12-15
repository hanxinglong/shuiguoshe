module CartsHelper
  def cart_tag
    if cart
      if cart.line_items.empty?
        cart_total = 0
      else
        cart_total = cart.total_items
      end
    else
      cart_total = 0
    end
    html = <<-HTML
      <a href="#{show_cart_path}" class="cart-result"><i class="green glyphicon glyphicon-shopping-cart"></i> 购物车<span class="green cart-total" id="cart-total-id" data-cart-total="#{cart_total}">#{cart_total}</span>件</a>
    HTML
    html.html_safe
  end
end
