class Photo < ActiveRecord::Base
  belongs_to :product
  
  mount_uploader :image, PhotoUploader
  
  attr_accessor :image_cache
  
  validates :image, presence: true
end
