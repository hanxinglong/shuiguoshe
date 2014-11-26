class Apartment < ActiveRecord::Base
  validates :name, :address, :image, presence: true
  
  mount_uploader :image, PictureUploader
  
  scope :opened, -> { where(:is_open => true) }
end
