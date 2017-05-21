# == Schema Information
#
# Table name: series
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :string
#  country           :string
#  seasons           :integer
#  chapters_duration :integer
#  rating            :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#

class Series < ApplicationRecord
  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' },
                             default_url: '/images/:style/default-img.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors, uniq: true
  has_and_belongs_to_many :genders
  has_and_belongs_to_many :viewers, class_name: 'User'
  has_many :ratings, class_name: 'SeriesRating'
  has_many :chapters, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 200 }
  validates :country, presence: true, length: { minimum: 1, maximum: 30 },
                   format: { with: /\A[a-zñ '-]+\z/i,
                             message: 'El país debe estar compuesto solo
                                           por letras, espacios, guiones y
                                          apostrofes.' }
  validates :rating, numericality: { grater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     message: 'debe ser un numero entre 1 y 5' }
  searchable do
    text :name
  end
end
