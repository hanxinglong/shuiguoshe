# coding: utf-8
module ProductsHelper
  def render_product_icon(product, size = :small)
    return "" if product.blank?
    return "" if product.image.blank?
    
    image_tag product.image.url(size)
  end
  
  def render_product_summary(product)
    return "" if product.blank?
    
    return product.subtitle if product.subtitle.present?
    return truncate(product.intro, length: 15) if product.intro.present?
    return ""
  end
end
