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
  
  def edit
    @user = current_user
    # 首次生成用户 Token
    # @user.update_private_token if @user.private_token.blank?
  end
  
  def update
    super
  end
end