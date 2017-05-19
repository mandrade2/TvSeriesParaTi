
user_amount = 10
child_amount = 3

user_amount.times do |i|
  user = User.new(
    username: Faker::Internet.user_name(6..40) + i.to_s,
    name: Faker::Name.name,
    role: 'user',
    email: i.to_s + Faker::Internet.email,
    password: Faker::Internet.password
  )
  user.skip_confirmation!
  user.save
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
    country = Faker::Lorem.word
    Series.create!(name: name, description: description, country: country,
                   user_id: user.id, rating: 1)
  end
end

main = User.create(
  username: 'jecastro2',
  name: 'Juan Castro',
  role: 'admin',
  email: 'jecastro2@uc.cl',
  password:  'mypassword',
  confirmed_at: Time.now
)
main.save

2.times do
  name = Faker::Lorem.word
  description = Faker::Lorem.paragraph(1)
  country = Faker::Lorem.word
  Series.create!(name: name, description: description, country: country,
                 user_id: main.id, rating: 1)
end
