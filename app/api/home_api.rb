module Shuiguoshe
  class HomeAPI < Grape::API
    resource :sections do
      params do
        optional :area_id, type: Integer, desc: "区域ID"
      end
      get '/' do
        area_id = params[:area_id].to_i
        if area_id == 0
          area_id = 1
        end
        
        area = Area.opened.find_by(id: area_id)
        if area.blank?
          return { code: 404, message: "未找到该区域" }
        end
        
        @banners = area.banners.sorted
        @catalogs = ProductType.all_types
        @items = Product.hot.saled.no_discount.order("sort ASC, id DESC").limit(6)
        
        sections = []
        if @banners.any?
          sections << { name: "", identifier: "banners", data_type: "Banner", height: 120, data: @banners }
        end
        
        if @catalogs.any?
          sections << { name: "分类选购",identifier: "catalogs", data_type: "Catalog", height: (@catalogs.count + 1) / 2 * 68 + 30, data: @catalogs }
        end
        
        if @items.any?
          sections << { name: "热门订购",identifier: "hot_items", data_type: "Item", height: ( ( @items.count + 1 ) / 2 * 250 + 30 + 20), data: @items }
        end
        
        { code: 0, message: "ok", data: sections }
      end
    end
  end
end