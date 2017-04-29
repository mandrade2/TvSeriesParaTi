# Usuarios comunes

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

main = User.create(
  username: 'jecastro2',
  name: 'Juan Castro',
  role: 'admin',
  email: 'jecastro2@uc.cl',
  password:  'mypassword',
  confirmed_at: Time.now
)

child_amount.times do |j|
  main.children.create(
    username: (j).to_s + Faker::Internet.user_name(6..40),
    name: Faker::Name.name,
    role: 'child',
    email: Faker::Internet.email,
    password:  Faker::Internet.password
  )
end
