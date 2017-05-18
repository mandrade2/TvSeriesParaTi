# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  name       :string
#  duration   :string
#  series_id  :integer
#  user_id    :integer
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chapter < ApplicationRecord
  belongs_to :series
  belongs_to :user

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :duration, presence: true, numericality: { only_integer: true }
  validates :rating, numericality: { grater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 7,
                                     message: 'Debe ser un numero entre 1 y 7' }
  validates :user_id, presence: true
end
