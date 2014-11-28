# coding: utf-8
class UsersController < ApplicationController
  before_action :require_user
  
  layout 'user_layout'
  
  def home
    
  end
  
  def show
    
  end
  
  def orders
    @user = User.find_by_id(params[:id])
    
    if @user && @user == current_user
      @orders = current_user.orders.order("created_at DESC").paginate page: params[:page], per_page: 10
      @current = '/all'
    else
      render_404
    end
    
  end
end