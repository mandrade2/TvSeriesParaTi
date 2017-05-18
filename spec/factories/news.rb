# == Schema Information
#
# Table name: news
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :news, class: 'News' do
    title Faker::Lorem.sentence(5)
    content Faker::Lorem.paragraph(5)
    user create(:user)
  end
end
