# coding: utf-8
class AccountController < Devise::RegistrationsController
  protect_from_forgery
  
  layout :layout_by_action
  def layout_by_action
    if %w(edit update).include?(action_name)
      "user_layout"
    elsif %w(new create).include?(action_name)
      "user_login"
    end
  end
  
  def new
    set_seo_meta('会员注册')
    super
  end
  
  def edit
    @user = current_user
    
    if params[:by] == 'pwd'
      set_seo_meta("修改密码")
      @current = 'user_edit_pwd'
    else
      set_seo_meta("修改基本资料")
      @current = 'user_edit_profile'
    end
    
    
    # 首次生成用户 Token
    # @user.update_private_token if @user.private_token.blank?
  end
  
  def update
    super
  end
  
  protected

    def after_sign_up_path_for(resource)
      home_user_path
    end
    
    def after_update_path_for(resource)
      home_user_path
    end
  
end