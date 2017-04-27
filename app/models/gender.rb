# == Schema Information
#
# Table name: genders
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Gender < ApplicationRecord
  has_and_belongs_to_many :series
  validates :name, presence: true, uniqueness: true,
                   format: { with: /\A[a-z '-]+\z/i,
                             message: 'Nombre debe estar compuesto solo
                                      por letras, espacios, guiones y
                                      apostrofes.' },
                   length: { minimum: 2, maximum: 50 }
end
