def get_api_poster(poster)
  configuration = Tmdb::Configuration.new
  configuration.secure_base_url + configuration.poster_sizes[1] + poster
end

user_amount = 10

user_amount.times do |i|
  user = User.new(
    username: Faker::Internet.unique.user_name(6..10),
    name: Faker::Name.name,
    role: 'user',
    email: i.to_s + Faker::Internet.email,
    password: Faker::Internet.password,
    # avatar: Faker::Avatar.image
  )
  user.skip_confirmation!
  user.save
end

user_amount.times do |i|
  user = User.new(
    username: Faker::Internet.unique.user_name(6..10),
    name: Faker::Name.name,
    role: 'admin',
    email: i.to_s + Faker::Internet.email,
    password: Faker::Internet.password,
    # avatar: Faker::Avatar.image
  )
  user.skip_confirmation!
  user.save
end
gender = Tmdb::Genre.list['genres'].map { |x| x['name'] }.compact
gender.each do |i|
  Gender.create(name: i)
end

50.times do |i|
  Actor.create(name: Tmdb::Person.detail(i * 3)['name'],
               nacionality: Tmdb::Person.detail(i * 3)['origin_country'])
  Director.create(name: Tmdb::Person.detail(i * 3 - 1)['name'],
              nacionality: Tmdb::Person.detail(i * 3 - 1)['origin_country'])
end

User.all.each do |user|
  2.times do
    title = Faker::Lorem.sentence(1)
    content = Faker::Lorem.paragraph(3)
    News.create(content: content, title: title, user_id: user.id)
  end
end


main = User.create!(
  username: 'jecastro2',
  name: 'Juan Castro',
  role: 'admin',
  email: 'jecastro2@uc.cl',
  password:  'mypassword',
  confirmed_at: Time.now,
  avatar: Faker::Avatar.image
)
main.save
series = Tmdb::TV.top_rated
20.times do |i|
  name = series[i].name
  description = series[i].overview
  country = series[i].origin_country[0]
  release_date = series[i].first_air_date
  image = get_api_poster(series[i].poster_path)
  serie = Series.new(name: name, description: description, country: country,
                     user_id: main.id,
                     rating: Random.rand(1..5), for_children: false,
                     release_date: release_date)
  serie.image_from_url(image)
  if serie.save
    temp = Season.new(series_id: serie.id, number: 1)
    temp.save
    5.times do |e|
      episode = Tmdb::Episode.detail(series[i].id, 1, e + 1)
      unless episode.nil?
        Chapter.new(name: episode['name'],
                    chapter_number: e + 1,
                    season_id: temp.id,
                    description: episode['overview'],
                    duration: Random.rand(25..45),
                    rating: Random.rand(1..5),
                    release_date: episode['air_date']).save
      end
    end
  end
end

Series.all.each do |serie|
  serie.actors << Actor.order('RANDOM()').first
  serie.directors << Director.order('RANDOM()').first
  serie.genders << Gender.order('RANDOM()').first
  serie.seasons = serie.real_seasons.count
  chapters_duration = 0
  total = 0
  serie.real_seasons.each do |season|
    chapters_duration += season.chapters.sum(:duration)
    total += season.chapters.count
  end
  total += 1 if total.zero?
  serie.chapters_duration = (chapters_duration / total).floor
  serie.save
end
