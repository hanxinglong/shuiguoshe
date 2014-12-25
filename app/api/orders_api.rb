module Shuiguoshe
  class OrdersAPI < Grape::API
    
    resource :user do
      # 1.获取所有订单
      params do
        requires :token, type: String, desc: "token"
        requires :page, type: Integer, desc: "页码"
      end
      get :orders do
        user = authenticate!
        @orders = user.orders.order("created_at DESC").paginate page: params[:page], per_page: page_size
      end
      
    end
    
    # 2.下订单
    # 3.取消订单
    # 4.获取某个订单下的详情
    
  end
end