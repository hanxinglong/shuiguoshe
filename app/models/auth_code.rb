class AuthCode < ActiveRecord::Base
  validates :mobile, presence: true, uniqueness: true
  
  before_create :generate_code
  def generate_code
    begin
      self.code = rand.to_s[2..7]
    end while self.class.exists?(code: self.code)
  end
end
