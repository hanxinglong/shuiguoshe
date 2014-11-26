class OrdersController < ApplicationController
  before_filter :require_user
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def new
    @product = Product.find(params[:product_id])
    @order = @product.orders.build
    respond_with(@order)
  end

  def create
    @product = Product.find(params[:product_id])
    @order = @product.orders.new(order_params)
    @order.user_id = current_user.id
    if @order.save
      flash[:success] = "预订成功"
      redirect_to root_path
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
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:product_id, :quantity, :apartment, :note)
    end
end
