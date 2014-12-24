# coding: utf-8
require "rest_client"

module Shuiguoshe
  class UsersAPI < Grape::API
    # 100 用户已经注册
    # 101 发送验证码失败
    # 102 不正确的手机号
    # 103 密码太短
    
    # use Rack::Session::Cookie, :secret => "1175ebb529d2cc7b6523755577dc298fba3a8587b01242751bf6c4d285b4178fc71616e9ea830a078a5f4cd3c5e33822fa008ae4bb4dc512028dc3a8da24c8f4" 
    
    use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = Shuiguoshe::UsersAPI
    end
    # 
    # Warden::Manager.serialize_into_session { |user| user.id }
    # Warden::Manager.serialize_from_session { |id| User.find(id) }
    # 
    # Warden::Strategies.add(:password) do
    #   
    #   def valid?
    #     params['login'] && params['password']
    #   end
    #   
    #   def authenticate!
    #     user = User.where(["mobile = :value OR lower(email) = :value", { value: params['login'].downcase }]).first
    #     if user && user.authenticate(params['password'])
    #       success! user
    #     else
    #       fail!("登录名或密码不正确")
    #     end
    #   end
    #   
    # end
    
    resource :auth_codes do  
      
      # 获取验证码
      params do
        requires :mobile, type: String
      end
      post '/' do
        unless check_mobile(params[:mobile])
          return { code: 102, message: "不正确的手机号" }
        end
        
        user = User.find_by(mobile: params[:mobile])
        if user.present?
          return { code: 100, message: "#{params[:mobile]}已经注册" }
        end
        
        code = AuthCode.where('mobile = ? and verified = ?', params[:mobile], true).first
        if code.blank?
          code = AuthCode.create!(mobile: params[:mobile])
        end

        if code
          RestClient.post('http://yunpian.com/v1/sms/send.json', "apikey=7612167dc8177b2f66095f7bf1bca49d&mobile=#{params[:mobile]}&text=您的验证码是#{code.code}【水果社】") { |response, request, result, &block|
            # puts response
            resp = JSON.parse(response)
            if resp['code'] == 0
              { code: 0, message: "ok" }
            else
              { code: 101, message: '发送失败' }
            end
          }
        end
        
      end # end post create_code
      
    end # end auth_codes
    
    resource :account do
      # 用户注册
      params do
        requires :mobile, type: String, desc: "用户手机"
        requires :code, type: String, desc: "验证码"
        requires :password, type: String, desc: "密码"
      end
      
      post "/" do
        
        unless check_mobile(params[:mobile])
          return { code: 102, message: "不正确的手机号" }
        end
        
        user = User.find_by(mobile: params[:mobile])
        if user.present?
          return { code: 100, message: "#{params[:mobile]}已经注册" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:code], true).first
        
        if ac.blank?
          return { code: 105, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 103, message: "密码太短，至少为6位" }
        end
        
        @user = User.new(email: "#{params[:mobile].gsub(/\s+/,"")}@shuiguoshe.com", mobile: params[:mobile].gsub(/\s+/, ''), password: params[:password], password_confirmation: params[:password])
        if @user.save
          warden.set_user(@user)
          @user.ensure_private_token!
          ac.update_attribute('verified', false)
          { code: 0, message: "ok", data: @user }
        else
          { code: 104, message: "注册失败" }
        end
        
      end # end reg
      
      # 用户登录
      params do
        requires :login, type: String, desc: "登录名"
        requires :password, type: String, desc: "密码"
      end
      
      post '/login' do
        user = User.where(["mobile = :value OR lower(email) = :value", { value: params[:login].downcase }]).first
        unless user
          return { code: 201, message: "登录用户不存在" } 
        end
        
        if warden.authenticate!(:password)
          { code: 0, message: "ok", data: user }
        else
          { code: 202, message: "登录密码不正确" }
        end
        
      end # end login
      
      # 退出登录
      params do
        requires :token, type: String
      end
      post '/logout' do
        authenticate!
        
        warden.logout
        { code: 0, message: "ok" }
      end # end logout
      
      # 重置密码
      params do
        requires :code, type: String
        requires :mobile, type: String
        requires :password, type: String, desc: "new password"
      end
      post '/password/reset' do
        unless check_mobile(params[:mobile])
          return { code: 102, message: "不正确的手机号" }
        end
        @user = User.find_by(mobile: params[:mobile])
        if @user.blank?
          return { code: 203, message: "用户未注册" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile],params[:code],true).first
        if ac.blank?
          return { code: 105, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 103, message: "密码太短，至少为6位" }
        end
        
        if @user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 204, message: "重置密码失败" } 
        end
        
      end # end reset password
      
      # 修改密码
      params do
        requires :code, type: String
        requires :password, type: String, desc: "new password"
        requires :old_password, type: String, desc: "old password"
      end
      post '/password/update' do
        user = authenticate!
        
        unless warden.try(:authenticate, params[:old_password])
          return { code: 205, message: "旧密码不正确" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile],params[:code],true).first
        if ac.blank?
          return { code: 105, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 103, message: "密码太短，至少为6位" }
        end
        
        if user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 206, message: "未知原因的修改密码失败" }
        end
        
      end # end update password
      
    end # end account
    
    resource :user do
    end # end user
    
  end # end class
end # end module