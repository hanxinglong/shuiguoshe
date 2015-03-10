# coding: utf-8
class Cpanel::ProductTypesController < Cpanel::ApplicationController
  before_action :set_product_type, only: [:show, :edit, :update, :destroy]
  # before_action :check_is_super_manager
  
  def index
    if current_user.admin?
      @product_types = ProductType.order('id desc')
    else
      areas = Area.opened.where(user_id: current_user.id)
      @product_types = ProductType.where(area_id: areas.map { |a| a.id }).sorted
    end
    @product_types = @product_types.paginate page: params[:page], per_page: 30
  end

  def show
    @products = Product.where(type_id: params[:id]).saled.order('sort ASC, id DESC').paginate page: params[:page], per_page: 20
  end

  def new
    @product_type = ProductType.new
  end

  def edit
  end

  def create
    @product_type = ProductType.new(product_type_params)
    if @product_type.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_product_types_path
    else
      render :new
    end
  end

  def update
    if @product_type.update(product_type_params)
      flash[:notice] = "修改成功"
      redirect_to cpanel_product_types_path
    else
      render :edit
    end
  end

  def destroy
    @product_type.destroy
    redirect_to cpanel_product_types_url
  end

  private
    def set_product_type
      @product_type = ProductType.find(params[:id])
      if current_user.admin?
        return true
      elsif current_user.is_seller
        unless @product_type.seller == current_user
          render_404
        end
      else
        return false
      end
    end

    def product_type_params
      params.require(:product_type).permit(:name, :sort, :seller_id)
    end
    
end
