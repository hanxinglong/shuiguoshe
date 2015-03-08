# coding: utf-8
class Cpanel::AreasController < Cpanel::ApplicationController
  before_action :check_is_admin, except: [:destroy]
  # before_action :check_is_super_manager
  before_action :set_area, only: [:show, :edit, :update, :destroy, :open, :close]

  def index
    @areas = Area.order('created_at desc').paginate page: params[:page], per_page: 20
  end

  def show
    
  end

  def new
    @area = Area.new
  end

  def edit
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      flash[:notice] = "创建成功"
      redirect_to cpanel_areas_path
    else
      render :new
    end
  end
  
  def open
    @area.visible = true
    if @area.save
      render text: "1"
    else
      render text: "-1"
    end
  end
  
  def close
    @area.visible = false
    if @area.save
      render text: "1"
    else
      render text: "-1"
    end
  end

  def update
    if @area.update(area_params)
      flash[:notice] = "修改成功"
      redirect_to cpanel_areas_path
    else
      render :edit
    end
  end

  def destroy
    @area.destroy
    redirect_to cpanel_areas_url
  end

  private
    def set_area
      @area = Area.find(params[:id])
    end

    def area_params
      params.require(:area).permit(:name, :address, :sort, :user_id)
    end
end
