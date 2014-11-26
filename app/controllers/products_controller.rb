class ProductsController < ApplicationController

  respond_to :html, :json

  def index
    @products = Product.where(type_id: params[:type_id])
    respond_with(@products)
  end

  def show
    respond_with(@product)
  end

end
