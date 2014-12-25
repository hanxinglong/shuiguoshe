# coding: utf-8
require "rest_client"

module Shuiguoshe
  class UsersAPI < Grape::API
    # 100 用户已经注册
    # 101 发送验证码失败
    # 102 不正确的手机号
    # 103 密码太短
    
    resource :auth_codes do  
      
      # 获取验证码
      # api: domain/v1/auth_codes
      # params: { mobile:'', type:1,2,3 }
      params do
        requires :mobile, type: String
        requires :type, type: Integer # 1 表示注册获取验证码 2 表示重置密码获取验证码 3 表示修改密码获取验证码
      end
      post '/' do
        unless check_mobile(params[:mobile])
          return { code: 100, message: "不正确的手机号" }
        end
        
        unless %W(1 2 3).include?(params[:type].to_s)
          return { code: -1, message: "不正确的type参数" }
        end
        
        type = params[:type].to_i
        user = User.find_by(mobile: params[:mobile])
        if type == 1    # 注册
          if user.present?
            return { code: 101, message: "#{params[:mobile]}已经注册" }
          end
        else # 重置密码和修改密码
          if user.blank?
            return { code: 102, message: "#{params[:mobile].gsub(/\s+/,"")}未注册" }
          end
        end
        
        code = AuthCode.where('mobile = ? and verified = ? and c_type = ?', params[:mobile], true, type).first
        if code.blank?
          code = AuthCode.create!(mobile: params[:mobile], c_type: type)
        end

        if code
          RestClient.post('http://yunpian.com/v1/sms/send.json', "apikey=7612167dc8177b2f66095f7bf1bca49d&mobile=#{params[:mobile]}&text=您的验证码是#{code.code}【水果社】") { |response, request, result, &block|
            # puts response
            resp = JSON.parse(response)
            if resp['code'] == 0
              { code: 0, message: "ok" }
            else
              { code: 103, message: '获取验证码失败' }
            end
          }
        end
        
      end # end post create_code
      
    end # end auth_codes
    
    resource :account do
      # 用户注册
      # api: domain/v1/account/sign_up
      # params: { mobile: '', code: '', password: '' }
      params do
        requires :mobile, type: String, desc: "用户手机"
        requires :code, type: String, desc: "验证码"
        requires :password, type: String, desc: "密码"
      end
      
      post "/sign_up" do
        
        unless check_mobile(params[:mobile])
          return { code: 100, message: "不正确的手机号" }
        end
        
        user = User.find_by(mobile: params[:mobile])
        if user.present?
          return { code: 101, message: "#{params[:mobile]}已经注册" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:code], true).first
        
        if ac.blank?
          return { code: 104, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 105, message: "密码太短，至少为6位" }
        end
        
        @user = User.new(email: "#{params[:mobile].gsub(/\s+/,"")}@shuiguoshe.com", mobile: params[:mobile].gsub(/\s+/, ''), password: params[:password], password_confirmation: params[:password])
        if @user.save
          warden.set_user(@user)
          @user.ensure_private_token!
          ac.update_attribute('verified', false)
          { code: 0, message: "ok", data: { token: @user.private_token || "" } }
        else
          { code: 106, message: "用户注册失败" }
        end
        
      end # end reg
      
      # 用户登录
      # api: domain/v1/account/login
      # params: { login: '', password: '' }
      params do
        requires :login, type: String, desc: "登录名"
        requires :password, type: String, desc: "密码"
      end
      
      post '/login' do
        user = User.where(["mobile = :value OR lower(email) = :value", { value: params[:login].downcase }]).first
        unless user
          return { code: 102, message: "用户未注册" } 
        end
        
        if user.valid_password?(params[:password])
          { code: 0, message: "ok", data: { token: user.private_token || "" } }
        else
          { code: 107, message: "登录密码不正确" }
        end
        
      end # end login
      
      # 退出登录
      # api: domain/v1/account/logout
      # params: { token: '' }
      params do
        requires :token, type: String
      end
      post '/logout' do
        authenticate!
        
        warden.logout
        { code: 0, message: "ok" }
      end # end logout
      
      # 重置密码
      # api: domain/v1/account/password/reset
      # params: { code: '', mobile: '', password: '' }
      params do
        requires :code, type: String
        requires :mobile, type: String
        requires :password, type: String, desc: "new password"
      end
      post '/password/reset' do
        unless check_mobile(params[:mobile])
          return { code: 100, message: "不正确的手机号" }
        end
        @user = User.find_by(mobile: params[:mobile])
        if @user.blank?
          return { code: 102, message: "#{params[:mobile]}未注册" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile],params[:code],true).first
        if ac.blank?
          return { code: 104, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 105, message: "密码太短，至少为6位" }
        end
        
        if @user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 108, message: "重置密码失败" } 
        end
        
      end # end reset password
      
      # 修改密码
      # api: domain/v1/account/password/update
      # params: { code: '', password: '', old_password: '' }
      params do
        requires :code, type: String
        requires :password, type: String, desc: "new password"
        requires :old_password, type: String, desc: "old password"
      end
      post '/password/update' do
        user = authenticate!
        
        unless user.valid_password?(params[:old_password])
          return { code: 109, message: "旧密码不正确" }
        end
        
        ac = AuthCode.where('mobile = ? and code = ? and verified = ?', user.mobile,params[:code],true).first
        if ac.blank?
          return { code: 104, message: "验证码无效" }
        end
        
        if params[:password].length < 6
          return { code: 105, message: "密码太短，至少为6位" }
        end
        
        if user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 110, message: "修改密码失败" }
        end
        
      end # end update password
      
    end # end account
    
    resource :user do
      params do
        requires :token, type: String, desc: "token"
      end
      get :me do
        user = authenticate!
        
        { code: 0, message: "ok", data: user }
      end # end 
    end # end user
    
  end # end class
end # end module