FactoryGirl.define do
  factory :news, class: 'News' do
    title Faker::Lorem.sentence(5)
    content Faker::Lorem.paragraph(5)
    user create(:user)
  end
end
