# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  number     :integer
#  series_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Season < ApplicationRecord
  belongs_to :series
  has_many :chapters, dependent: :destroy
  validates :number, presence: true, numericality: { only_integer: true,
                                                     grater_than: 0 },
                     uniqueness: { scope: :series_id }
end
