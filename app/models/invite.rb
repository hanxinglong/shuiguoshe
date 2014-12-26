class Invite < ActiveRecord::Base
  validates :code, :invitee_mobile, :user_id, presence: true
  validates :invitee_mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }
  validates_uniqueness_of :code, :invitee_mobile
  
  belongs_to :user
  
  # before_create :generate_code
  # def generate_code
  #   begin
  #     self.code = SecureRandom.hex(3)
  #     puts self.code
  #   end while self.class.exists?(code: self.code)
  # end
  
end
