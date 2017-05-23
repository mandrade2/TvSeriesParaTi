# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  name                   :string
#  role                   :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  father_id              :integer
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class User < ApplicationRecord
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  belongs_to :father, class_name: 'User'

  has_many :children, class_name: 'User', foreign_key: :father_id
  has_many :news, dependent: :destroy
  has_many :chapters, dependent: :destroy
  has_many :series_ratings, class_name: 'SeriesRating'
  has_many :chapters_ratings, class_name: 'ChaptersRating'
  has_many :series, dependent: :destroy

  has_and_belongs_to_many :series_views, class_name: 'Series'
  has_and_belongs_to_many :chapters_views, class_name: 'Chapter'

  scope :email_like, (->(email) { where("email like '%#{email}%'") })
  scope :username_like,
        (->(username) { where("username like '%#{username}%'") })
  scope :name_like, (->(name) { where("name like '%#{name}%'") })

  after_create :set_defaults
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :lockable
  validates :username, presence: true, uniqueness: true,
                       length: { minimum: 6, maximum: 50 }
  validates :name, presence: true,
                   format: { with: /\A[a-z. '-]+\z/i,
                             message: '%{value} debe estar compuesto solo
                                      por letras, puntos, espacios, guiones y
                                      apostrofes.' },
                   length: { minimum: 2, maximum: 50 }

  def child?
    role == 'child' && !father_id.nil?
  end

  def user?
    role == 'user' && father_id.nil?
  end

  def admin?
    role == 'admin'
  end

  def upgrade_to_admin
    update_attribute :role, 'admin'
  end

  private

  def set_defaults
    self.role ||= 'user'
  end
end
