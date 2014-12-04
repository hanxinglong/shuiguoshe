class ApartmentsController < ApplicationController
  respond_to :html, :json
  def index
    @apartments = Apartment.opened.paginate page: params[:page], per_page: 30
    @hot_apartments = Apartment.hot.limit(10)
    set_seo_meta('服务小区')
  end
end
