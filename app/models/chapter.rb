# == Schema Information
#
# Table name: chapters
#
#  id             :integer          not null, primary key
#  name           :string
#  duration       :string
#  series_id      :integer
#  user_id        :integer
#  rating         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chapter_number :integer
#

class Chapter < ApplicationRecord
  belongs_to :series
  belongs_to :user
  has_and_belongs_to_many :viewers, class_name: 'User'
  has_many :ratings, class_name: 'ChaptersRating'
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :duration, presence: true, numericality: { only_integer: true }
  validates :rating, numericality: { grater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     message: 'debe ser un numero entre 1 y 5' }
  validates :user_id, presence: true
end
