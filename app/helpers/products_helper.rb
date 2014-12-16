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
  
  def product_price_tag(price)
    number_with_precision(price, precision: 2)
  end
  
  def render_deliver_info
    if Time.zone.now.strftime('%H:%M:%S') < '12:00:00'
      "温馨提示：12:00前完成下单，今天（#{Time.zone.now.strftime("%Y-%m-%d")}）18:00至21:00之间配送"
    else
      "温馨提示：23:00前完成下单，明天（#{(Time.zone.now + 1.day).strftime("%Y-%m-%d")}）18:00至21:00之间配送"
    end
  end
  
end
