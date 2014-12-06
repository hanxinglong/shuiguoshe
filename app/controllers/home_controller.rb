class HomeController < ApplicationController
  def index
    @banners = Banner.sorted.limit(4)
    @products = Product.hot.order("created_at DESC").limit(6)
    @suggest_products = Product.suggest.limit(6)
    @newsblasts = Newsblast.sorted.limit(5)
    @ads = SidebarAd.sorted.limit(4)
    @current = 'home_index'
    set_seo_meta(SiteConfig.home_title, SiteConfig.home_meta_keywords, SiteConfig.home_meta_description)
  end
  
  def about
    @current = 'home_about'
    set_seo_meta('关于水果社')
  end
  
  def help
    @current = 'home_help'
    set_seo_meta('帮助中心')
  end
  
end
