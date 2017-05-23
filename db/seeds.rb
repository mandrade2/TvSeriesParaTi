
user_amount = 10
child_amount = 3

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
  user.save!
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
  user.save!
end

User.all.each do |user|
  2.times do
    title = Faker::Lorem.sentence(5)
    content = Faker::Lorem.paragraph(1)
    News.create!(content: content, title: title, user_id: user.id)
  end

  2.times do
    name = Faker::Lorem.word
    description = Faker::Lorem.paragraph(1)
    country = Faker::Address.country
    p country unless /\A[a-z '-]+\z/i.match(country)
    Series.create!(name: name, description: description, country: country,
                   user_id: user.id, rating: Random.rand(1..5),
                   seasons: 0, image: Faker::LoremPixel.image)
  end
end

Series.all.each do |serie|
  (1..4).each do |i|
    Chapter.create!(name: Faker::Internet.unique.user_name(7..99),
                    duration: Random.rand(10..50),
                    chapter_number: i,
                    series_id: serie.id,
                    user_id: User.order('RANDOM()').first.id,
                    rating: Random.rand(1..5))
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
  Series.create!(name: name, description: description, country: country,
                 user_id: main.id, image: Faker::LoremPixel.image,
                 rating: Random.rand(1..5))
end
