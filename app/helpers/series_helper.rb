module SeriesHelper
  def get_api_poster(poster)
    configuration = Tmdb::Configuration.new
    configuration.secure_base_url + configuration.poster_sizes[1] + poster
  end
end
