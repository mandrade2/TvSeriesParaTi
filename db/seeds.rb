10.times do
  user = User.new(
    username: Faker::Internet.user_name(6..40),
    name: Faker::Name.name,
    role: 'user',
    email: Faker::Internet.email,
    password:  Faker::Internet.password
  )
  user.skip_confirmation!
  user.save
end
users = User.order(:created_at).take(6)
10.times do
  title = Faker::Lorem.sentence(5)
  content = Faker::Lorem.paragraph(5)
  users.each { |user| user.noticiums.create!(content: content, title: title) }
end

main = User.new(
  username: 'jecastro2',
  name: 'Juan Castro',
  role: 'admin',
  email: 'jecastro2@uc.cl',
  password:  'mypassword',

)

main.skip_confirmation!
main.save
title = Faker::Lorem.sentence(5)
content = Faker::Lorem.paragraph(5)
main.noticiums.create!(content: content, title: title)
title = Faker::Lorem.sentence(5)
content = Faker::Lorem.paragraph(5)
main.noticiums.create!(content: content, title: title)
title = Faker::Lorem.sentence(5)
content = Faker::Lorem.paragraph(5)
main.noticiums.create!(content: content, title: title)





main2 = User.new(
  username: 'mandrade2',
  name: 'matias andrade',
  role: 'admin',
  email: 'mandrade2@uc.cl',
  password:  'mypassword'
)

main2.skip_confirmation!
main2.save
title = Faker::Lorem.sentence(5)
content = Faker::Lorem.paragraph(5)
main.noticiums.create!(content: content, title: title)
title = Faker::Lorem.sentence(5)
content = Faker::Lorem.paragraph(5)
main.noticiums.create!(content: content, title: title)
title = Faker::Lorem.sentence(5)
content = Faker::Lorem.paragraph(5)
main.noticiums.create!(content: content, title: title)