# == Schema Information
#
# Table name: chapters_ratings
#
#  id         :integer          not null, primary key
#  rating     :integer
#  user_id    :integer
#  chapter_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChaptersRating < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
end
