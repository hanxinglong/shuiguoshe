class Banner < ActiveRecord::Base
  validates :image, presence: true
  
  mount_uploader :image, BannerUploader
  
  scope :sorted, -> { order("sort ASC, created_at DESC") }
end

# == Schema Information
#
# Table name: banners
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  intro      :string(255)
#  image      :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  sort       :integer          default(0)
#