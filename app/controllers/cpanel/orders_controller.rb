# coding: utf-8
class Cpanel::OrdersController < Cpanel::ApplicationController
  
  before_action :set_order, only: [:cancel, :complete]
  
  def index
    @orders = Order.includes(:user, :product).order('created_at DESC').paginate page: params[:page], per_page: 30
  end
  
  def search
    @orders = Order.search(params[:q]).order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end
  
  def today_normal
    
    @orders = Order.normal.today
    if params[:q]
      @orders = @orders.search(params[:q])
    end
    @orders = @orders.includes(:user, :product).order('created_at DESC').paginate page: params[:page], per_page: 30
    
    render :index
  end
  
  def completed
    @orders = Order.completed.includes(:user, :product).order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end
  
  def canceled
    @orders = Order.canceled.includes(:user, :product).order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end

  def cancel
    @order.cancel
    redirect_to cpanel_orders_path
  end
  
  def complete
    @order.complete
    redirect_to cpanel_orders_path
  end
  
  private
    def set_order
      @order = Order.find(params[:id])
    end
  
end
