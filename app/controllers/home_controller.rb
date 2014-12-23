class HomeController < ApplicationController
  layout 'help_layout', only: [:order_help, :pay_help, :deliver_help]
  def index
    @banners = Banner.sorted.limit(4)
    # @products = Product.hot.order("created_at DESC").limit(6)
    # @suggest_products = Product.suggest.limit(6)
    
    @sales = Sale.recent
    
    @newsblasts = Newsblast.sorted.limit(5)
    @ads = SidebarAd.sorted.limit(4)
    @discounted_products = Product.saled.discounted
    @current = 'home_index'
    # fresh_when(etag: [@banners, @sales, @newsblasts, @ads, @discounted_products, @current, SiteConfig.home_title, SiteConfig.home_meta_keywords, SiteConfig.home_meta_description])
    set_seo_meta(SiteConfig.home_title, SiteConfig.home_meta_keywords, SiteConfig.home_meta_description)
  end
  
  def about
    @current = 'home_about'
    set_seo_meta('关于水果社')
  end
  
  def order_help
    @current = 'order_help'
    set_seo_meta('帮助中心')
  end
  
  def pay_help
    @current = 'pay_help'
    set_seo_meta('帮助中心')
  end
  
  def deliver_help
    @current = 'deliver_help'
    set_seo_meta('帮助中心')
  end
  
  def error_404
    render_404
  end
  
end
