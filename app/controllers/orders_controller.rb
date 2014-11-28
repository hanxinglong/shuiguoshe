# coding: utf-8
class OrdersController < ApplicationController
  before_filter :require_user
  before_filter :check_user
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  
  layout 'user_layout', only: [:search, :incompleted, :completed, :canceled, :cancel]

  respond_to :html

  def check_user
    unless current_user.verified
      flash[:error] = "您的账号已经被冻结"
      redirect_to root_path
    end
  end
  
  def search
    @orders = current_user.orders.search(params[:q]).includes(:product).order("orders.created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders'
    render :index
  end
  
  # def all
  #   @orders = current_user.orders.order("created_at DESC").paginate page: params[:page], per_page: 10
  #   @current = '/all'
  #   render :index
  # end
  
  def incompleted
    @orders = current_user.orders.normal.includes(:product).order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders_incompleted'
    render :index
  end
  
  def completed
    @orders = current_user.orders.completed.includes(:product).order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders_completed'
    render :index
  end
  
  def canceled
    @orders = current_user.orders.canceled.includes(:product).order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders_canceled'
    render :index
  end
  
  def cancel
    @order = current_user.orders.find(params[:id])
    
    if Time.now.strftime('%Y-%m-%d %H:%M:%S') < @order.created_at.strftime('%Y-%m-%d 23:59:59')
      if @order.cancel
        @msg = "操作成功"
      else
        @msg = "操作失败"
      end
    else
      @msg = "对不起不能进行该操作"
    end
    
  end
  
  def new
    @product = Product.find(params[:product_id])
    @order = @product.orders.build
    
    set_seo_meta("预订#{@product.title}", @product.title, @product.intro)
    
    respond_with(@order)
  end

  def create
    @product = Product.find(params[:product_id])
    @order = @product.orders.new(order_params)
    @order.user_id = current_user.id
    if @order.save
      flash[:success] = "预订成功"
      redirect_to orders_user_path(current_user)
    else
      render :new
    end
    
  end

  def update
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  private
    def set_order
      @order = current_user.orders.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:product_id, :quantity, :deliver_address, :deliver_time, :note, :state)
    end
end
