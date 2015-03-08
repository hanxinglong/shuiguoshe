module Shuiguoshe
  class AreasAPI < Grape::API
    resource :areas do
      get '/' do
        @areas = Area.joins(:seller).where('users.is_seller = ?', true).opened        
        { code: 0, message: "ok", data: @areas }
      end
    end
  end
end