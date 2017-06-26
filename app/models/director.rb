# == Schema Information
#
# Table name: directors
#
#  id          :integer          not null, primary key
#  name        :string
#  nacionality :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Director < ApplicationRecord
  has_and_belongs_to_many :series, uniq: true
  has_many :favorites, as: :favorable
  has_many :fans, through: :favorites, source: :user

  validates :name, presence: true,
            format: {with: /\A[a-z '-]+\z/i,
                     message: 'Nombre debe estar compuesto solo
                                       por letras, espacios, guiones y
                                       apostrofes.'},
            length: {minimum: 2, maximum: 50}
end
