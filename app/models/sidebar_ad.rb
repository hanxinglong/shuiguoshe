class SidebarAd < ActiveRecord::Base
  validates :image, presence: true
  scope :sorted, -> { order('sort ASC, created_at DESC') }
  
  mount_uploader :image, SidebarAdUploader
end
