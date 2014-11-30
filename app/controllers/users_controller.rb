# coding: utf-8
class UsersController < ApplicationController
  before_action :require_user
  before_action :check_user
  layout 'user_layout'
  
  def home
    @orders = current_user.orders.today.normal.order("created_at DESC").paginate page: params[:page], per_page: 10
  end
  
  def edit
    @user = current_user
    @current = 'user_edit_other'
  end
  
  def update
    user_params = params.require(:user).permit(:deliver_time,:deliver_address)
    if current_user.update(user_params)
      flash[:success] = "修改成功"
      redirect_to edit_user_path
    else
      render :edit
    end
  end
  
  def update_address
    @success = true
    @user = User.find_by_id(params[:user_id])
    @user.deliver_address = params[:address]
    if @user.deliver_address.blank?
      return
    end
    
    if not @user.save
      @success = false
    end
  end
  
  def points
    @traces = ScoreTrace.where(user_id: current_user.id).order("created_at DESC").paginate page: params[:page], per_page: 30
    @current = 'user_points'
  end
  
  def orders
    @orders = current_user.orders.order("created_at DESC").paginate page: params[:page], per_page: 10
    @current = 'user_orders'    
  end
end