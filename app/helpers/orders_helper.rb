module OrdersHelper
  
  def render_orders_total_price(orders)
    return 0.0 if orders.blank?
    return 0.0 if orders.empty?
    
    sum = 0
    orders.each do |order|
      sum += order.total_price
    end
    
    sum
    
  end
  
  def render_order_state(order)
    return "" if order.blank?
    
    if order.normal?
      content_tag :span, "待配送", class: "label label-warning", style: "font-size: 14px;"
    elsif order.canceled?
      content_tag :span, "已取消", class: "label label-danger", style: "font-size: 14px;"
    elsif order.completed?
      content_tag :span, "已完成", class: "label label-success", style: "font-size: 14px;"
    end
  end
  
  def can_cancel?(order)
    return false if order.blank?
    
    ( order.can_cancel? and
      ( Time.now.strftime("%Y-%m-%d %H:%M:%S") < order.created_at.strftime("%Y-%m-%d 23:59:59") ) and
      owner?(order) )
  end
end
