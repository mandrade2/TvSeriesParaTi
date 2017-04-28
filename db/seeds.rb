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

main = User.new(
  username: 'jecastro2',
  name: 'Juan Castro',
  role: 'admin',
  email: 'jecastro2@uc.cl',
  password:  'mypassword'
)
main.skip_confirmation!
main.save
