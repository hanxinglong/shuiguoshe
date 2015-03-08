class Area < ActiveRecord::Base
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
