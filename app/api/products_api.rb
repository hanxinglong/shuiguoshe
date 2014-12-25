module Shuiguoshe
  class ProductsAPI < Grape::API
    # 卖场
    resource :sales do
      # 获取所有卖场信息
      get '/' do
        @sales = Sale.recent
        if @sales.empty?
          return { code: 404, message: "数据为空" }
        end
        
        { code: 0, message:"ok", data: @sales }
      end # end get '/'
      
      # 获取卖场详细信息
      get '/:id' do
        @sale = Sale.includes(:products).find_by(id: params[:id])
        if @sale.blank?
          return { code: 404, message: "没有记录" }
        end
        
        @items = @sale.products
        # if @items.empty?
        #   return { code: 404, message: "没有记录" }
        # end
        
        { code: 0, message: "ok", 
          data: { 
            ad_image_url: @sale.ad_image_url,
            items: @items
          } 
        }
      end # end get '/:id'
      
    end # end sale
    
    resource :items do
      
      # 获取每日特惠商品
      get '/discounted' do
        @items = Product.saled.discounted
        if @items.empty?
          return { code: 404, message: "没有记录" }
        end
        { code: 0, message: "ok", data: @items }
      end # end
      
      get '/:id' do
        @product = Product.find_by(id: params[:id])
        if @product.blank?
          return { code: 404, message: "没有找到记录" }
        end
        
        { code: 0, message: "ok",
          data: {
            title: @product.title || "",
            intro: @product.intro || "",
            large_image: @product.large_image_url,
            low_price: format("%.2f", @product.low_price),
            origin_price: format("%.2f", @product.origin_price),
            unit: @product.units || "",
            orders_count: @product.orders_count,
            delivered_at: @product.delivered_time,
            deliver_info: deliver_info_for(@product)
          } 
        }
      end # end
      
    end # end resource
    
  end
end