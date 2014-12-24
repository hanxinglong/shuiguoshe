# coding: utf-8
require "helpers"
require "users_api"

module Shuiguoshe
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