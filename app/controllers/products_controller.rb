class ProductsController < ApplicationController

  def index
    @products = Product.saled.no_discount
    
    if params[:type_id]
      type_id = params[:type_id].to_i
    else
      type_id = 1
    end
    
    if type_id < 1 or type_id > 2
      type_id = 1
    end
    
    params[:type_id] = type_id
    
    @products = @products.where(type_id: type_id)
    
    # @suggested_products = Product.suggest.where(type_id: params[:type_id])
    # @hot_products = Product.hot.where(type_id: params[:type_id])
    
    if params[:q] && params[:q].gsub(/\s+/, "").present?
      @products = @products.search(params[:q])
      keyword = params[:q].gsub(/\s+/, "")
      if @products.size > 0
        set_seo_meta("#{keyword} - 商品搜索", "#{keyword}", "在#{Setting.app_name}中找到了#{@products.size}件#{keyword}的类似商品，其中包括了“#{@products.map(&:title).join('、')}”等类型的#{keyword}的商品。")
        @cache_prefix = "products_#{type_id}_#{keyword}"
      else
        set_seo_meta("#{keyword} - 商品搜索")
        @cache_prefix = "products_#{type_id}"
      end
    else
      if type_id == 1
        set_seo_meta('当季水果，新鲜水果订购区', @products.map(&:title).join('、'), SiteConfig.fruit_meta_description)
      else
        set_seo_meta('各种干果、坚果订购区', @products.map(&:title).join('、'), SiteConfig.nut_meta_description)
      end
      
      @cache_prefix = "products_#{type_id}"
    end
    
    fresh_when(etag: [@products, @cache_prefix, params[:q]])
    
  end
  
  def show
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid product #{params[:id]}"
    # @order = @product.orders.build
      render_404
    else
      fresh_when etag: @product
      set_seo_meta(@product.title, '', @product.intro)
      
      if @product.type_id == 1
        @type = '水果'
      else
        @type = '干果'
      end
      
    end
  end

end
