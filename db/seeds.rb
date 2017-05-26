
user_amount = 10

user_amount.times do |i|
  user = User.new(
    username: Faker::Internet.unique.user_name(6..10),
    name: Faker::Name.name,
    role: 'user',
    email: i.to_s + Faker::Internet.email,
    password: Faker::Internet.password,
    avatar: Faker::Avatar.image
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
    avatar: Faker::Avatar.image
  )
  user.skip_confirmation!
  user.save
end

User.all.each do |user|
  2.times do
    title = Faker::Lorem.sentence(5)
    content = Faker::Lorem.paragraph(1)
    News.create(content: content, title: title, user_id: user.id)
  end

  2.times do
    name = Faker::Lorem.word
    description = Faker::Lorem.paragraph(1)
    country = Faker::Address.country
    Series.create(name: name, description: description, country: country,
                  user_id: user.id, rating: Random.rand(1..5),
                  seasons: 0, image: Faker::LoremPixel.image)
  end
end

Series.all.each do |serie|
  (1..4).each do |i|
    season = Season.new(series_id: serie.id, number: i)
    if season.save
      (1..2).each do |e|
        Chapter.create(
          name: Faker::Lorem.word,
          chapter_number: e,
          season_id: season.id,
          duration: Random.rand(25..45),
          rating: Random.rand(1..5)
        )
      end
    else
      p 'falle'
    end
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

2.times do
  name = Faker::Lorem.word
  description = Faker::Lorem.paragraph(1)
  country = Faker::Address.country
  Series.create(name: name, description: description, country: country,
                user_id: main.id, image: Faker::LoremPixel.image,
                rating: Random.rand(1..5))
end

Series.all.each do |serie|
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
