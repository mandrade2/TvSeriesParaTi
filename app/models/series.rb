# == Schema Information
#
# Table name: series
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :string
#  country            :string
#  seasons            :integer
#  chapters_duration  :integer
#  rating             :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Series < ApplicationRecord
  has_attached_file :image, styles: {medium: '300x300>', thumb: '100x100>'},
                    default_url: '/images/:style/default-img.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors, uniq: true
  has_and_belongs_to_many :genders
  has_and_belongs_to_many :viewers, class_name: 'User'
  has_many :ratings, class_name: 'SeriesRating', dependent: :destroy
  has_many :chapters, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: {minimum: 1, maximum: 50}
  validates :description, presence: true, length: {minimum: 10, maximum: 200}
  validates :country, presence: true, length: {minimum: 1, maximum: 50}
  validates :rating, numericality: {grater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5,
                                    message: 'debe ser un numero entre 1 y 5'}

  def self.search(nombre, pais, rating1,rating2,capitulo,director,actor,genero)
    @series=Series.all
    series=[]
    if nombre.present?
      series<<@series.where(name: nombre)
    end
    if pais.present?
      series<<@series.where(country: pais)
    end
    if rating1.present? and rating2.present?
      series<<@series.where(rating: rating1..rating2)
    end

    for serie in @series
      puts serie.actors
      puts serie.directors
      puts serie.genders
      puts serie.chapters
      if capitulo.present?
        series<<serie.actors.where(name: capitulo)
      end
      if director.present?
        series<<@series.where(director: director)
      end
      if actor.present?
        series<<serie.actors.where(name: actor)
      end
      if genero.present?
        series<<@series.where(gender: genero)
      end
    end

    @series=series

  end
end
