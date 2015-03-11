class ShipmentType < ActiveRecord::Base
  
  WEEK_DAYS = %w[周日 周一 周二 周三 周四 周五 周六]
   
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
      prefix: self.prefix
    }
  end
  
  def prefix
    order_time_line = SiteConfig.order_time_line || '12:00:00'
    if Time.zone.now.strftime("%H:%M:%S") < order_time_line
      "今天（#{WEEK_DAYS[Time.zone.now.wday]}）"
    else
      "明天（#{WEEK_DAYS[Time.zone.now.wday]}）"
    end
  end
end
