
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
    5.times do
      title = Faker::Lorem.sentence(5)
      content = Faker::Lorem.paragraph(1)
      user.news.new(content: content, title: title)
    end

    5.times do
      name = Faker::Lorem.word
      description = Faker::Lorem.paragraph(1)
      country = Faker::Lorem.word
      Series.create!(name: name, description: description, country: country,
                     user_id: user.id
                     )
    end

    0.times do |j|
      user.children.create(
        username: (j).to_s + Faker::Internet.user_name(6..40),
        name: Faker::Name.name,
        role: 'child',
        email: Faker::Internet.email,
        password:  Faker::Internet.password
      )
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
