class DeliverInfo < ActiveRecord::Base
  def as_json(opts)
    {
      id: self.id,
      mobile: self.mobile || "",
      address: self.address || "",
    }
  end
end
