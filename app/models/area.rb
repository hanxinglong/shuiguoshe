class Area < ActiveRecord::Base
  
  has_and_belongs_to_many :banners
  
  scope :opened, -> { where(visible: true).recent }
  scope :recent, -> { order('sort ASC, id DESC') }
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
      address: self.address || "",
      sort: self.sort,
    }
  end
end
