class MessagesController < ApplicationController
  before_action :require_user
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  layout 'user_layout'
  respond_to :html

  def index
    @messages = Message.all
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def new
    @message = Message.new
    respond_with(@message)
  end

  def edit
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    if @message.save
      flash[:success] = "留言成功!"
      redirect_to new_message_path
    else
      render :new
    end
  end

  def update
    @message.update(message_params)
    respond_with(@message)
  end

  def destroy
    @message.destroy
    respond_with(@message)
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:title, :body)
    end
end
