class DeliverInfo < ActiveRecord::Base
  
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 },
            :presence => true
            
  # validates :apartment_id, inclusion: { in: Apartment.opened.map { |a| a.id }, message: "%{value} 不是一个有效的值" }
  validates :area_id, presence: true
  
  belongs_to :user
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
      mobile: self.mobile || "",
      address: self.user_address,
    }
  end
  
  def user_address
    a = Area.find_by(id: area_id)
    s = self.address || ""
    if a.blank?
      s
    else
      if s.length > 0
        "#{a.name}（#{s}）"
      else
        "#{a.name}（#{a.address}）"
      end
      
    end
  end
  
end
