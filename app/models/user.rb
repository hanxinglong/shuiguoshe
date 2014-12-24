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
  
  def apartment
    @apartment ||= Apartment.find_by_id(self.apartment_id).try(:name)
  end

  # 注册邮件提醒
  after_create :send_welcome_mail
  def send_welcome_mail
    # 生成token
    update_private_token
    # 赠送积分
    update_score(1000, '成功注册')
    # 发送欢迎邮件
    UserMailer.welcome(self.id).deliver
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
  
  # 更新积分
  def update_score(ss, msg = '')
    summary = msg.blank? ? '' : "#{msg}, "
    if ss > 0
      # 赠送积分
      if self.update_attribute('score', self.score + ss)
        # 生成积分交易记录
        ScoreTrace.create!(score: ss, summary: "#{summary}赠送#{ss}积分", user_id: self.id)
      end
    else
      if ( self.score + ss ) >= 0
        # 抵扣积分
        if self.update_attribute('score', self.score + ss)
          # 生成积分交易记录
          ScoreTrace.create!(score: -ss, summary: "#{summary}抵扣￥#{format("%.2f", (-ss/100.0))}", user_id: self.id)
        end
      end
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

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  mobile                 :string(255)
#  avatar                 :string(255)
#  deliver_time           :string(255)      default("")
#  deliver_address        :string(255)      default("")
#  verified               :boolean          default(TRUE)
#  private_token          :string(255)
#  score                  :integer          default(0)
#  apartment_id           :integer
#
