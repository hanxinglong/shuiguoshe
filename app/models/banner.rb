class Banner < ActiveRecord::Base
  validates :image, presence: true
  
  mount_uploader :image, BannerUploader
  
  scope :sorted, -> { order("sort ASC, created_at DESC") }
end
