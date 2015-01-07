class ProductsController < ApplicationController

  def index
    @products = Product.saled.no_discount
    
    type_id = params[:type_id].to_i

    if type_id < 1
      type_id = 1
    end
    
    if type_id > 3
      type_id = 3
    end
    
    params[:type_id] = type_id
    
    @products = @products.where(type_id: type_id).order("created_at DESC")
    
    titles = SiteConfig.product_meta_titles.split('#') if SiteConfig.product_meta_titles
    descriptions = SiteConfig.product_meta_descriptions.split('#') if SiteConfig.product_meta_descriptions
    if titles and descriptions
      set_seo_meta(titles[type_id - 1], @products.map(&:title).join('、'), descriptions[type_id - 1])
    end

    @cache_prefix = "products_#{type_id}"
    
    fresh_when(etag: [@products, @cache_prefix])
    # puts @products.map { |p| "#{p.title} - #{p.id}" }
  end
  
  def search
    
    keyword = params[:q].gsub(/\s+/, "")
    
    @products = Product.saled.no_discount.search(keyword)
    
    if @products.size > 0
      set_seo_meta("#{keyword} - 商品搜索", "#{keyword}", "在#{Setting.app_name}中找到了#{@products.size}件#{keyword}的类似商品，其中包括了“#{@products.map(&:title).join('、')}”等类型的#{keyword}的商品。")
      @cache_prefix = "products_search_results_#{keyword}"
    else
      set_seo_meta("#{keyword} - 商品搜索")
      @cache_prefix = "products_search_no_results_#{keyword}"
    end
    
    fresh_when(etag: [@products, @cache_prefix, keyword])
    # render :index
        
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
