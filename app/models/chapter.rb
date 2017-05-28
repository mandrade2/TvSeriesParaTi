# == Schema Information
#
# Table name: chapters
#
#  id             :integer          not null, primary key
#  name           :string
#  rating         :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chapter_number :integer
#  season_id      :integer
#  duration       :integer
#  description    :string
#

class Chapter < ApplicationRecord
  belongs_to :season
  has_and_belongs_to_many :viewers, class_name: 'User'
  has_many :ratings, class_name: 'ChaptersRating'
  validates :name, presence: true, length: {minimum: 3, maximum: 50}
  validates :duration, presence: true, numericality: {only_integer: true,
                                                      grater_than_or_equal_to: 1}
  validates :rating, numericality: {grater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5,
                                    message: 'debe ser un numero entre 1 y 5'}
  validates :chapter_number, uniqueness: {scope: :season_id}, numericality: {
      only_integer: true,
      grater_than_or_equal_to: 1}

  def self.search(nombre, pais, serie, director, actor, genero,duracion)
    @chapters=Chapter.all
    chapters=[]
    if nombre.present?
      cap=@chapters.where('name ILIKE ?',"%#{nombre}%")
      if cap
        chapters<<cap
      end
    end
    if duracion.present?
      cap=@chapters.where('duration ILIKE ?',"%#{duracion}%")
      if cap
        chapters<<cap
      end
    end

    for series in Series.all#por terminar falta aun
      if series.name==serie
        for chap2 in series.chapters
          if chap2.name==nombre
            chapters<<chap2
          end
        end
      end
    end
    @chapters=chapters

  end
end
