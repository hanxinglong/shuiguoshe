class Area < ActiveRecord::Base
  
  has_many :product_types, dependent: :destroy
  
  has_and_belongs_to_many :banners
  
  # 输入某个商家
  belongs_to :seller, class_name: "User", foreign_key: "user_id"
  
  scope :opened, -> { where(visible: true).recent }
  scope :recent, -> { order('sort ASC, id DESC') }
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
      address: self.address || "",
      sort: self.sort,
      # seller: self.seller.try(:mobile) || "",
    }
  end
  
  def self.opened_areas_for(user)
    if user.admin?
      opened
    elsif user.is_seller
      opened.where(user_id: user.id)
    else
      []
    end
  end
  
  def user_name
    if seller
      seller.mobile
    else
      ""
    end
  end
  
  def sorted_types
    self.product_types.sorted
  end
end
