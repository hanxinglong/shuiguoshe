class Apartment < ActiveRecord::Base
  validates :name, :address, :image, presence: true
  
  mount_uploader :image, PictureUploader
  
  scope :opened, -> { where(:is_open => true) }
  scope :hot, -> { where('orders_count > 0').order('orders_count desc') }
  
  def add_order_count
    self.class.increment_counter(:orders_count, self.id)
  end
  
end
