# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  name       :string
#  duration   :string
#  series_id  :integer
#  user_id    :integer
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :chapter do
    name "MyString"
    duration "MyString"
    series nil
    user nil
    rating 1
  end
end
