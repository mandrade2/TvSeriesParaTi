class SeriesRating < ApplicationRecord
  belongs_to :user
  belongs_to :series
end
