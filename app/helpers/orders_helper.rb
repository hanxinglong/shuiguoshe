module OrdersHelper
  def render_order_state(order)
    return "" if order.blank?
    
    if order.normal?
      content_tag :span, "待配送", class: "label label-warning"
    elsif order.canceled?
      content_tag :span, "已取消", class: "label label-danger"
    elsif order.completed?
      content_tag :span, "已完成", class: "label label-success"
    end
    
  end
end
