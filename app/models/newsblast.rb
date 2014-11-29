class Newsblast < ActiveRecord::Base
  scope :sorted, -> { order("sort ASC, created_at DESC") }
end
