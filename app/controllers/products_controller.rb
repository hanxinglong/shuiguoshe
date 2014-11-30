class ProductsController < ApplicationController

  respond_to :html, :json

  def index
    @products = Product.saled.where(type_id: params[:type_id])
    @suggested_products = Product.suggest.where(type_id: params[:type_id])
    @hot_products = Product.hot.where(type_id: params[:type_id])
    respond_with(@products)
  end
  
  def search
    @suggested_products = Product.suggest.where(type_id: params[:type_id])
    @hot_products = Product.hot.where(type_id: params[:type_id])
    
    @products = Product.saled.search(params[:q])
    unless params[:type_id].blank?
      @products = @products.where(type_id: params[:type_id])
    end
    render :index
  end

  def show
    respond_with(@product)
  end

end
