class News < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
  validates :title, presence: true, length: { maximum: 140 }

  def any?
    :user.news.count()>0
  end
end
