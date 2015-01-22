class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user
  
  scope :recent, -> { order('id desc') }
  scope :products, -> { where(likeable_type: "Product") }
end
