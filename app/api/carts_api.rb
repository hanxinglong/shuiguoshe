module Shuiguoshe
  class CartsAPI < Grape::API
    resource :user do
      # 我的购物车
      params do
        requires :token, type: String, desc: "token"
      end
      get :cart do
        if current_cart.line_items_count == 0
          return { code: 111, message: "购物车是空的" }
        end
  
        line_items = current_cart.line_items.order("created_at DESC")
        { code: 0, message: "ok", data: { total: current_cart.line_items_count, total_price: format("%.2f",current_cart.total_price), items:line_items } }
      end
    end # end user
    
    resource :cart do
      # 加入购物车
      params do
        requires :token, type: String, desc: "token"
        requires :pid, type: Integer, desc: "产品id"
      end
      post '/add_item' do
        @product = Product.find_by(id: params[:pid])
        if @product.blank?
          return { code: 404, message: "没有该产品" }
        end
        
        if @product.stock_count <= 0
          return { code: 112, message: "产品已售完" }
        end
        
        @cart = current_cart
        @line_item = current_cart.add_product(@product)
        
        if @line_item.save
          @cart.update_items_count(1)
          { code: 0, message: "ok", data: @line_item }
        else
          { code: 113, message: "加入购物车失败" }
        end
        
      end # end add
      
      # 修改购物车
      params do
        requires :token, type: String, desc: "token"
        requires :id, type: Integer, desc: "购物项id"
        requires :quantity, type: Integer, desc: "修改数量"
      end
      post '/update_item' do
        item = LineItem.find_by(id: params[:id])
        if item.blank?
          return { code: 404, message: "没有该购物项" }
        end
        
        if params[:quantity].to_i < 1
          return { code: -1, message: "购买数量必须大于1" }
        end
        
        if params[:quantity].to_i > item.product.stock_count
          return { code: -1, message: "购买数量必须小于或等于库存" }
        end
        
        old_count = item.quantity
        new_count = params[:quantity].to_i
        
        if item.update_attribute(:quantity, new_count)
          # 更新购物车总数
          current_cart.update_items_count(new_count - old_count)
          { code: 0, message: "ok", data: item }
        else
          { code: 114, message: "更新购物项数量失败" }
        end
        
      end # end update
      
      params do
        requires :token, type: String, desc: "token"
        requires :value, type: String, desc: "id:quantity," # 2:1,107:3
      end
      post '/update_items' do
        values = params[:value].split(',')
        if values.empty?
          return { code: -1, message: "购物项参数错误" }
        end
        
        sum = 0
        counter = 0
        items = []
        values.each do |value|
          id, num = value.split(':')
          item = LineItem.find_by(id: id)
          if item.blank?
            return { code: 404, message: "没有该购物项" }
          end
        
          if num.to_i < 1
            return { code: -1, message: "购买数量必须大于1" }
          end
        
          if num.to_i > item.product.stock_count
            return { code: -1, message: "购买数量必须小于或等于库存" }
          end
        
          old_count = item.quantity
          new_count = num.to_i
          
          if item.update_attribute(:quantity, new_count)
            counter += 1
            sum += new_count - old_count
            items << item
          end
          
        end
        
        if counter == values.count
          current_cart.update_items_count(sum)
          { code: 0, message: "ok", data: items }
        else
          { code: 114, message: "更新购买项数量失败" }
        end
        
        
      end # end update many items
      
      # 删除购物项
      params do
        requires :token, type: String, desc: "token"
        requires :ids, type: String, desc: "需要删除的购买项" # 106,107
      end
      post '/delete_items' do
        ids = params[:ids].split(",")
        items = LineItem.where(id: ids)
        if items.empty?
          return { code: 404, message: "没有找到购买项" }
        end
        
        sum = 0
        items.each do |item|
          sum += item.quantity
        end
        
        current_cart.update_items_count(-sum)
        items.destroy_all
        { code: 0, message: "ok" }
      end # end delete_items
      
    end
  end
end