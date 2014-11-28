class Message < ActiveRecord::Base
  validates :title, :body, presence: true
end
