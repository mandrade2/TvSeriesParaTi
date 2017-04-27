json.extract! series, :id, :name, :description, :country, :seasons, :chapters_duration, :rating, :created_at, :updated_at
json.url series_url(series, format: :json)
