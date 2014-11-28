# coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]
         
  attr_accessor :login, :password_confirmation
  
  mount_uploader :avatar, AvatarUploader
  
  ACCESSABLE_ATTRS = [:login, :mobile, :email, :by, :avatar, :password, :password_confirmation, :current_password]
  
  has_many :orders, dependent: :destroy
  
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }, 
            :presence => true, :uniqueness => true
  
  # 重写devise认证
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["mobile = :value OR lower(email) = :value", { value: login.downcase}]).first
    else
      where(conditions).first
    end
  end
  
  def login
    self.mobile || self.email
  end

  # 注册邮件提醒
  after_create :send_welcome_mail
  def send_welcome_mail
    # 生成token
    update_private_token
    # 赠送积分
    update_score
    # 发送欢迎邮件
    # UserMailer.welcome(self.id).deliver
  end

  def update_with_password(params = {})
    if !params[:current_password].blank? or !params[:password].blank? or !params[:password_confirmation].blank?
      super
    else
      params.delete(:current_password)
      self.update_without_password(params)
    end
  end
  
  def admin?
    Setting.admin_emails.include?(self.email)
  end
  
  def update_score
    default_score = 1000
    self.score += default_score
    if self.save
      # 生成积分交易记录
      ScoreTrace.create!(score: default_score, summary: "成功注册，赠送#{default_score}积分", user_id: self.id)
    end
  end

  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update_attribute(:private_token, random_key)
  end
  # 
  # def ensure_private_token!
  #   self.update_private_token if self.private_token.blank?
  # end
            
end
