module Shuiguoshe
  class AreasAPI < Grape::API
    resource :areas do
      get '/' do
        @areas = Area.opened        
        { code: 0, message: "ok", data: @areas }
      end
    end
  end
end