# coding: utf-8
class Cpanel::ProductsController < Cpanel::ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.order('created_at desc').paginate page: params[:page], per_page: 30
  end

  def show
    
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_products_path
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "修改成功"
      redirect_to cpanel_products_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to cpanel_products_url
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:type_id, :title, :subtitle, :intro, :image, :image_cache, :low_price, :origin_price)
    end
end
