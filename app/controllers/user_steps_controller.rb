class UserStepsController < ApplicationController
  
  layout 'user_login'
  
  def new
    @user = User.new
  end
  
  def create
    user = User.find_by(mobile: params[:user][:mobile])
    if user.blank?
      @user = User.new
      @user.errors.add(:mobile, "用户未注册")
      render :new
    else
      user.update_attribute(:reset_password_token, SecureRandom.uuid.gsub(/-/, "")) if user.reset_password_token.blank?
      redirect_to find_password_path(key: user.reset_password_token)
    end
  end
  
  def find
    @user = User.find_by(reset_password_token: params[:key])
  end
end