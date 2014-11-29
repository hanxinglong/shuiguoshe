class HomeController < ApplicationController
  def index
    @banners = Banner.sorted.limit(4)
    @products = Product.saled.order("created_at DESC").limit(6)
    @newsblasts = Newsblast.sorted.limit(5)
    @ads = SidebarAd.sorted.limit(4)
  end
  
  def about
    
  end
  
  def help
    
  end
  
end
