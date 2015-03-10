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
        
        @catalogs = ProductType.where(seller_id: area.seller.id).sorted.includes(:hot_products)
        
        sections = []
        if @banners.any?
          sections << { name: "", identifier: "banners", data_type: "Banner", height: 120, data: @banners }
        end
        
        if @catalogs.any?
          
          @catalogs.each do |cata|
            
            sections << { name: cata.name, identifier: "catalog-#{cata.id}", data_type: "Item", height: (cata.hot_products.size + 1) / 2 * 247 + 30, data: cata.hot_products }
          end
          
        end
        
        { code: 0, message: "ok", data: sections }
      end
    end # end resource sections
    
    resource :payment_and_shipment_infos do
      get '/' do
        json = {}
        @payment_types = PaymentType.order('sort ASC, id DESC')
        if @payment_types.any?
          json[:payment_type] = @payment_types.as_json
        end
        @shipment_types = ShipmentType.order('sort ASC, id DESC')
        if @shipment_types.any?
          json[:shipment_type] = @shipment_types.as_json
        end
        
        { code: 0, message: "ok", data: json }
        
      end
    end # end resources payment_and_shipment_infos
  end
end