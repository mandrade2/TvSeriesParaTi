FactoryGirl.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  sequence(:username) { |n| "#{Faker::Internet.user_name}#{n}" }
end

FactoryGirl.define do
  factory :user, class: 'User' do
    name Faker::Name.name
    username
    email
    password '12345678'
    password_confirmation '12345678'
    role 'user'
    confirmed_at Time.now
  end
end
