# coding: utf-8
require "helpers"
require "users_api"

module Shuiguoshe
  ####################################################################
  # code状态码
  # 0: 表示成功
  # -1: 表示参数错误
  # 100: 不正确的手机号
  # 101: 用户已经注册
  # 102: 用户未注册，用于获取重置验证码，修改密码验证码，用户登录
  # 103: 获取验证码失败
  # 104: 验证码无效
  # 105: 密码太短
  # 106: 用户注册失败
  # 107: 用户登录密码不正确
  # 108: 重置密码失败
  # 109: 旧密码不正确
  # 110: 修改密码失败
  ####################################################################
  class APIV1 < Grape::API
    version 'v1'
    format :json
    
    rescue_from :all do |e|
      case e
      when ActiveRecord::RecordNotFound
        Rack::Response.new(['not found'], 404, {}).finish
      else
        Rails.logger.error "APIv1 Error: #{e}\n#{e.backtrace.join("\n")}"
        Rack::Response.new(['error'], 500, {}).finish
      end
    end
    
    helpers APIHelpers
    
    mount Shuiguoshe::UsersAPI
  end
end