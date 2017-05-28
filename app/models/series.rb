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
  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' },
                             default_url: '/images/:style/default-img.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors, uniq: true
  has_and_belongs_to_many :genders
  has_and_belongs_to_many :viewers, class_name: 'User'
  has_many :ratings, class_name: 'SeriesRating', dependent: :destroy
  has_many :real_seasons, class_name: 'Season', dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 200 }
  validates :country, presence: true, length: { minimum: 1, maximum: 50 }
  validates :rating, numericality: { grater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     message: 'debe ser un numero entre 1 y 5' }

  def self.search(nombre, pais, rating1, rating2,
                  capitulo, director, actor, genero)
    @series = Series.all
    series = []
    if nombre.present?

      serie=@series.where(name: nombre)
      if serie
        series<<serie
      end
    end
    if pais.present?
      serie=@series.where(country: pais)
      if serie
        series<<serie
      end
    end
    if rating1.present? and rating2.present?
      serie=@series.where(rating: rating1..rating2)
      if serie
        series<<serie
      end
    end
    
    for serie in @series
      if capitulo.present?
        serie2=serie.chapters.where(name: capitulo)
        if serie2
          series<<serie2
        end
      end
      if director.present?
        serie2=serie.directors.where(name: director)
        if serie2
          series<<serie2
        end
      end
      if actor.present?
        serie2=serie.actors.where(name: actor)
        if serie2
          series<<serie2
        end
      end
      if genero.present?
        serie2=serie.genders.where(name: genero)
        if serie2
          series<<serie2
        end

      end
    end

    @series = series
  end
end
