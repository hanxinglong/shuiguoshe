class HomeController < ApplicationController
  def index
    @banners = Banner.sorted.limit(4)
  end
end
