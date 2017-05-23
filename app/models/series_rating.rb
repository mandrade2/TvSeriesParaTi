# == Schema Information
#
# Table name: series_ratings
#
#  id         :integer          not null, primary key
#  rating     :integer
#  user_id    :integer
#  series_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SeriesRating < ApplicationRecord
  belongs_to :user
  belongs_to :series
end
