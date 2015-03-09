# coding: utf-8
class Cpanel::OrdersController < Cpanel::ApplicationController
  # before_action :check_is_admin, except: [:destroy]
  before_action :set_order, only: [:cancel, :complete, :prepare_deliver, :deliver, :show]
  
  def index
    if current_user.admin?
      @orders = Order.includes(:user)
    else
      @orders = current_user.orders
    end
    @orders = @orders.order('id DESC').paginate page: params[:page], per_page: 30
  end
  
  def show
    
  end
  
  def search
    if current_user.admin?
      @orders = Order.search(params[:q])
    else
      @orders = current_user.orders.search(params[:q])
    end
    
    @orders = @orders.order('id DESC').paginate page: params[:page], per_page: 30
    render :index
  end
  
  def today_normal
    if current_user.admin?
      @orders = Order.normal.today.includes(:user)
    else
      @orders = current_user.orders.normal.today.includes(:user)
    end
    @orders = @orders.order('created_at DESC').paginate page: params[:page], per_page: 30
    
    render :index
  end
  
  def completed
    
    if current_user.admin?
      @orders = Order.completed.includes(:user)
    else
      @orders = current_user.orders.completed.includes(:user)
    end
    
    @orders = @orders.order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end
  
  def canceled
    
    if current_user.admin?
      @orders = Order.canceled.includes(:user)
    else
      @orders = current_user.orders.canceled.includes(:user)
    end
    
    @orders = @orders.order('created_at DESC').paginate page: params[:page], per_page: 30
    render :index
  end

  def cancel
    @order.cancel
    redirect_to cpanel_orders_path
  end
  
  def prepare_deliver
    @order.prepare_deliver!
    if params[:for] == 'home'
      redirect_to cpanel_root_path
    else
      redirect_to cpanel_orders_path
    end
    
  end
  
  def deliver
    @order.deliver
    # redirect_to cpanel_orders_path
    if params[:for] == 'home'
      redirect_to cpanel_root_path
    else
      redirect_to cpanel_orders_path
    end
  end
  
  def complete
    @order.complete
    # redirect_to cpanel_orders_path
    if params[:for] == 'home'
      redirect_to cpanel_root_path
    else
      redirect_to cpanel_orders_path
    end
  end
  
  private
    def set_order
      if current_user.admin?
        @order = Order.find(params[:id])
      else
        @order = current_user.orders.find(params[:id])
      end
    end
  
end
