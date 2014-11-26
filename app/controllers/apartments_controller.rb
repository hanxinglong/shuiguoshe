class ApartmentsController < ApplicationController
  respond_to :html, :json
  def index
    @apartments = Apartment.opened.paginate page: params[:page], per_page: 30
  end
end
