class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def recalcular_rating(serie)
    if serie.ratings.empty?
      serie.rating = 1
    else
      serie.rating = serie.ratings.average(:rating)
    end
    serie.save
  end

  def actualizar_serie(serie)
    serie.seasons = serie.real_seasons.count
    chapters_duration = 0
    total = 0
    serie.real_seasons.each do |season|
      chapters_duration += season.chapters.sum(:duration)
      total += season.chapters.count
    end
    serie.chapters_duration = (chapters_duration / total).floor
    serie.save
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username avatar])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[name username avatar])
  end
end
