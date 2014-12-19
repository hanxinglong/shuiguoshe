class ScoreTrace < ActiveRecord::Base
end


# == Schema Information
#
# Table name: score_traces
#
#  id         :integer          not null, primary key
#  score      :integer
#  summary    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#