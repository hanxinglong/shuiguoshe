class HomeController < ApplicationController
  def index
    @banners = Banner.sorted.limit(4)
    @products = Product.hot.order("created_at DESC").limit(6)
    @suggest_products = Product.suggest.limit(6)
    @newsblasts = Newsblast.sorted.limit(5)
    @ads = SidebarAd.sorted.limit(4)
    @current = 'home_index'
  end
  
  def about
    @current = 'home_about'
  end
  
  def help
    @current = 'home_help'
  end
  
end
