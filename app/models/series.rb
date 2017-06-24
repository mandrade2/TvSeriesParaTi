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

class ReleaseValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:release_date] << 'es mayor a la fecha actual' if
        record.release_date.nil? || record.release_date > DateTime.current
  end
end

class Series < ApplicationRecord

  has_attached_file :image, styles: {medium: '300x300>', thumb: '100x100>'},
                    default_url: '/images/:style/default-img.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_and_belongs_to_many :actors
  has_and_belongs_to_many :directors, uniq: true
  has_and_belongs_to_many :genders
  has_and_belongs_to_many :viewers, class_name: 'User'
  has_many :ratings, class_name: 'SeriesRating', dependent: :destroy
  has_many :real_seasons, class_name: 'Season', dependent: :destroy
  has_many :comments, dependent: :destroy

  # favorites
  has_many :favorites, as: :favorable
  has_many :fans, through: :favorites, source: :user

  belongs_to :user
  validates :name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :description, presence: true, length: {minimum: 10, maximum: 200}
  validates :country, presence: true, length: {minimum: 1, maximum: 50}
  validates :rating, numericality: {grater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5,
                                    message: 'debe ser un numero entre 1 y 5'}
  validates :release_date, presence: true
  validates_with ReleaseValidator

  def self.get_series_by_role(user)
    if user
      if user.admin?
        @series = Series.all
      elsif user.child?
        @series = Series.joins(:user).where(users: { role: 'admin' }).or(
          Series.joins(:user).where(users: { id: user.father_id })
        )
      else
        @series = Series.joins(:user).where(users: { role: 'admin' }).or(
          Series.joins(:user).where(users: { id: user.id })
        )
      end
    else
      @series = Series.joins(:user).where(users: { role: 'admin' })
    end
  end

  def self.search(user, nombre, pais, rating1, rating2,
                  capitulo, director, actor, genero)
    @series = get_series_by_role(user)
    series = []
    if nombre.present?
      @series = @series.where('series.name ILIKE ?', "%#{nombre}%")
    end
    @series = @series.where('country ILIKE ?', "%#{pais}%") if pais.present?
    if rating1.present? && rating2.present?
      @series = @series.where(rating: rating1..rating2)
    end

    @series.each do |serie2|
      if capitulo.present?
        added = false
        serie2.real_seasons.each do |season|
          if season.chapters.where('name ILIKE ?', "%#{capitulo}%").count > 0
            added = true
            break
          end
        end
        next if added == false
      end
      if director.present?
        director_search = serie2.directors.where(
          'name ILIKE ?', "%#{director}%"
        )
        next unless director_search.count > 0
      end
      if actor.present?
        next unless serie2.actors.where('name ILIKE ?', "%#{actor}%").count > 0
      end
      if genero.present?
        gender_search = serie2.genders.where(
          'name ILIKE ?', "%#{genero}%"
        )
        next unless gender_search.count > 0
      end
      series << serie2
    end

    @series = series
  end
end
