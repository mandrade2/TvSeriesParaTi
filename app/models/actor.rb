# == Schema Information
#
# Table name: actors
#
#  id          :integer          not null, primary key
#  name        :string
#  nacionality :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Actor < ApplicationRecord
  has_and_belongs_to_many :series
  validates :name, presence: true,
                   format: { with: /\A[a-z '-]+\z/i,
                             message: 'Nombre debe estar compuesto solo
                                      por letras, espacios, guiones y
                                      apostrofes.' },
                   length: { minimum: 2, maximum: 50 }
end
