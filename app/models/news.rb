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

class News < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: 1000}
  validates :title, presence: true, length: {maximum: 140}

  def any?
    :user.news.count()>0
  end
end
