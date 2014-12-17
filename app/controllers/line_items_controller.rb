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
    @product_id = "product-#{@product.id}"
    
    @success = false
    if @line_item.save
      @success = true
      @cart.update_items_count(1)
      # render text: "1"
    else
      # render text: "-1"
    end
    
  end

  def update
    @type = params[:type]
    @success = false
    if params[:type] == '-1'
      if @line_item.quantity > 1
        @line_item.quantity -= 1
        if @line_item.save
          @success = true
          cart.update_items_count(-1)
        end
      end
    elsif params[:type] == '1'
      @line_item.quantity += 1
      if @line_item.save
        @success = true
        cart.update_items_count(1)
      end
    end
    
    @line_item_id = "line_item_#{@line_item.id}"
  end

  def destroy
    @line_item_id = "line_item_#{@line_item.id}"
    @success = true
    if @line_item.destroy
      @success = true
      cart.update_items_count(- @line_item.quantity)
    else
      @success = false
    end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

end
