class Sale < ActiveRecord::Base
  has_many :products
  
  validates :cover_image, :title, presence: true
  
  mount_uploader :cover_image, CoverImageUploader
  mount_uploader :ad_image, SaleAdImageUploader
  mount_uploader :logo, SaleLogoUploader
  
  scope :recent, -> { order('created_at DESC') }
end

# == Schema Information
#
# Table name: sales
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  cover_image :string(255)
#  ad_image    :string(255)
#  subtitle    :string(255)
#  logo        :string(255)
#  background_color :string(255) 卖场背景颜色
#  closed_at   :datetime  卖场活动截止日期, 默认为空，表示不截止
#  created_at  :datetime
#  updated_at  :datetime
#
