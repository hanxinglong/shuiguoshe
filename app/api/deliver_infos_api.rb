module Shuiguoshe
  class DeliverInfosAPI < Grape::API
    resource :deliver_infos do
      params do
        requires :token, type: String
      end
      get '/' do
        user = authenticate!
        @infos = DeliverInfo.where(user_id: user.id).order('id desc')
        { code: 0, message: "ok", data: @infos }
        
      end
      
      # 新建
      params do
        requires :token, type: String
        # requires :item, type: Hash # { mobile: xxx, apartment_id: 1, address: xxxx }
        requires :mobile, type: String
        requires :area_id, type: Integer
        optional :name, type: String
      end
      
      post '/' do
        user = authenticate!
        di = DeliverInfo.where(user_id: user.id, area_id: params[:area_id], mobile: params[:mobile]).first
        if di.blank?
          DeliverInfo.create!(user_id: user.id, area_id: params[:area_id], mobile: params[:mobile], name: params[:name])
        end
        { code: 0, message: "ok" }
      end # end 新建
      
      # 删除
      params do
        requires :token, type: String
      end
      
      post '/:id' do
        user = authenticate!
        info = DeliverInfo.where(user_id: user.id, id: params[:id]).first
        info.destroy!
        { code: 0, message: "ok" }
      end # end 删除
      
    end
  end
end