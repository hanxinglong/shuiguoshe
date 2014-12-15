class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @line_items = LineItem.all
    
  end

  def show
    
  end

  def new
    @line_item = LineItem.new
    
  end

  def edit
  end

  def create
    @cart = current_cart
    @product = Product.find(params[:product_id])
    @line_item = @cart.add_product(@product)

    @result_dom_id = "result-#{@product.id}"
    @item_id = "item-#{@product.id}"
    
    @success = false
    if @line_item.save
      @success = true
      # render text: "1"
    else
      # render text: "-1"
    end
    
  end

  def update
    @type = params[:type]
    if params[:type] == '-1'
      if @line_item.quantity > 1
        @line_item.quantity -= 1
        @line_item.save
      end
    elsif params[:type] == '1'
      @line_item.quantity += 1
      @line_item.save
    end
    
    @cart = current_cart
    @line_item_id = "line_item_#{@line_item.id}"
  end

  def destroy
    @line_item_id = "line_item_#{@line_item.id}"
    @cart = current_cart
    @line_item.destroy
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

end
