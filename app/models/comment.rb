# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  series_id  :integer
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :series
  has_and_belongs_to_many :likes, class_name: 'User',
                                  join_table: 'comments_users'

  validates :content, length: {minimum: 1, maximum: 255}
end
