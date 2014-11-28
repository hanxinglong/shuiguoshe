# coding: utf-8
class UsersController < ApplicationController
  before_action :require_user
  
  layout 'user_layout'
  
  def home
    @orders = current_user.orders.today.normal.order("created_at DESC").paginate page: params[:page], per_page: 10
  end
  
  def show
    
  end
  
  def orders
    @user = User.find_by_id(current_user.id)
    
    if @user
      @orders = @user.orders.order("created_at DESC").paginate page: params[:page], per_page: 10
      @current = 'user_orders'
    else
      render_404
    end
    
  end
end