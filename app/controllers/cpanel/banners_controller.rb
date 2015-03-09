class Cpanel::BannersController < Cpanel::ApplicationController
  # before_action :check_destroy_authorize, except: [:destroy]
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin?
      @banners = Banner.sorted
    else
      areas = Area.opened_areas_for(current_user)
      @banners = Banner.joins(:areas).where('areas_banners.area_id = ?', areas.map(&:id)).sorted
    end
  end

  def new
    @banner = Banner.new
  end

  def edit
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      # flash[:success] = "创建成功"
      redirect_to cpanel_banners_path
    else
      render :new
    end
  end

  def update
    if @banner.update(banner_params)
      # flash[:success] = "修改成功"
      redirect_to cpanel_banners_path
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to cpanel_banners_url
  end

  private
    def set_banner
      @banner = Banner.find(params[:id])
      if not current_user.admin?
        if @banner.areas.first.seller != current_user
          render_404
        else
          return true
        end
      else
        return true
      end
    end

    def banner_params
      params.require(:banner).permit(:title, :subtitle, :intro, :image, :url, :sort, { :area_ids => [] })
    end
    
end
