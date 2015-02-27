module Shuiguoshe
  class DeliverInfosAPI < Grape::API
    resource :deliver_infos do
      get '/' do
        user = authenticate!
        @infos = DeliverInfo.where(user_id: user.id).order('id desc')
        { code: 0, message: "ok", data: @infos }
        
      end
    end
  end
end