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
  has_many :ratings, class_name: 'ChaptersRating', dependent: :destroy
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :duration, presence: true,
                       numericality: { only_integer: true,
                                       grater_than_or_equal_to: 1 }
  validates :rating, numericality: { grater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     message: 'debe ser un numero entre 1 y 5' }
  validates :chapter_number, uniqueness: { scope: :season_id },
                             numericality: {
                               only_integer: true,
                               grater_than_or_equal_to: 1
                             }

  def self.search(nombre, pais, serie, director, actor, genero, duracion)
    @chapters = Chapter.all
    if nombre.present?
      @chapters = @chapters.where('name ILIKE ?', "%#{nombre}%")
    end
    @chapters = @chapters.where(duration: duracion.to_i) if duracion.present?
    @chapters = @chapters.includes(
      season:
      [
        series: %i[user actors directors genders]
      ]
    )
    searched_chapters = []

    @chapters.each do |chapter|
      # Busqueda por pais
      if pais.present?
        unless chapter.season.series.country.match?(/#{Regexp.escape pais}/i)
          next
        end
      end
      # Busqueda por serie
      if serie.present?
        next unless chapter.season.series.name.match?(/#{Regexp.escape serie}/i)
      end
      # Search por director
      if director.present?
        do_next = true
        chapter.season.series.directors.each do |series_director|
          if series_director.name.match?(/#{Regexp.escape director}/i)
            do_next = false
            break
          end
        end
        next if do_next
      end
      # Busqueda por actor
      if actor.present?
        do_next = true
        chapter.season.series.actors.each do |series_actor|
          if series_actor.name.match?(/#{Regexp.escape actor}/i)
            do_next = false
            break
          end
        end
        next if do_next
      end
      # Busqueda por genero
      if genero.present?
        do_next = true
        chapter.season.series.genders.each do |series_gender|
          if series_gender.name.match?(/#{Regexp.escape genero}/i)
            do_next = false
            break
          end
        end
        next if do_next
      end
      searched_chapters << chapter
    end
    @chapters = searched_chapters
  end
end
