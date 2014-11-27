# coding: utf-8
class AccountController < Devise::RegistrationsController
  protect_from_forgery
  
  layout 'user_layout'
  def edit
    @user = current_user
    # 首次生成用户 Token
    # @user.update_private_token if @user.private_token.blank?
  end
  
  def update
    super
  end
end