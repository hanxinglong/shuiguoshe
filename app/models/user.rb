# coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]
         
  attr_accessor :login, :password_confirmation
  
  mount_uploader :avatar, AvatarUploader
  
  ACCESSABLE_ATTRS = [:login, :mobile, :email, :by, :avatar, :password, :password_confirmation, :current_password]
  
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }, 
            :presence => true, :uniqueness => true
end
