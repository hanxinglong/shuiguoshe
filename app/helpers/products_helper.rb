# coding: utf-8
module ProductsHelper
  def render_product_icon(product, size = :small)
    return "" if product.blank?
    return "" if product.image.blank?
    
    image_tag product.image.url(size)
  end
end
