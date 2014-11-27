class ProductType < ActiveRecord::Base
  
  def self.all_types
    @product_types ||= ProductType.all
  end
  
end
