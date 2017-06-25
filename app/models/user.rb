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
#  sign_in_count          :integer          default(0), not null
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
#  failed_attempts        :integer          default(0), not null
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
  # avatar
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  belongs_to :father, class_name: 'User'
  has_many :children, class_name: 'User', foreign_key: :father_id,
                      dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :father, class_name: 'User'
  has_and_belongs_to_many :series_views, class_name: 'Series',
                                         dependent: :destroy
  has_and_belongs_to_many :chapters_views, class_name: 'Chapter',
                                           dependent: :destroy
  has_and_belongs_to_many :likes, class_name: 'Comment',
                                  join_table: 'comments_users'
  has_many :series_ratings, class_name: 'SeriesRating', dependent: :destroy
  has_many :chapters_ratings, class_name: 'ChaptersRating', dependent: :destroy
  has_many :series, dependent: :destroy

  # favorites
  has_many :favorites, dependent: :destroy
  has_many :favorite_directors, through: :favorites,
                                source: :favorable, source_type: 'Director'
  has_many :favorite_actors, through: :favorites,
                             source: :favorable, source_type: 'Actor'
  has_many :favorite_genders, through: :favorites,
                              source: :favorable, source_type: 'Gender'
  has_many :favorite_series, through: :favorites,
                             source: :favorable, source_type: 'Series'
  has_many :favorite_chapters, through: :favorites,
                               source: :favorable, source_type: 'Chapter'

  # scopes

  scope :email_like, (->(email) { where("email like '%#{email}%'") })
  scope :username_like,
        (->(username) { where("username like '%#{username}%'") })
  scope :name_like, (->(name) { where("name like '%#{name}%'") })

  before_create :set_defaults
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :lockable, :omniauthable, :omniauth_providers => [:facebook,:google,:twitter]

  validates :username, presence: true, uniqueness: true,
                       length: { minimum: 6, maximum: 50 }
  validates :name, presence: true,
                   format: { with: /\A[a-z. '-]+\z/i,
                             message: '%{value} debe estar compuesto solo
                                      por letras, puntos, espacios,
                                      guiones y apostrofes.' },
                   length: { minimum: 2, maximum: 50 },
                   exclusion: { in: %w[series news favorites help contact about
                                       myseries invite search search_chapter],
                                message: '%{value} is reserved.' }

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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end
  def self.new_with_session(params, session)
    super.tap do |user|
      puts params
      puts session
      puts user.inspect
      puts params == session["devise.facebook_data"]
      puts session["devise.facebook_data"]["extra"]["raw_info"]
      if session["devise.facebook_data"]
        user.email = session["devise.facebook_data"]["extra"]["raw_info"]["email"] if user.email.blank?
        user.name=session["devise.facebook_data"]["extra"]["raw_info"]["name"] if user.name.blank?
        user.avatar_file_name=open(session["devise.facebook_data"]["info"]["image"]) if user.avatar_file_name.blank?
      end
    end
  end

  private

  def set_defaults
    self.role ||= 'user'
  end
end
