class User < ActiveRecord::Base
  include Geocodable
  include SkillMatchable

  before_create -> { self.auth_token = SecureRandom.hex }

  belongs_to :language

  has_many :user_skills
  has_many :skills, through: :user_skills

  has_many :owned_jobs, class_name: 'Job', foreign_key: 'owner_user_id'

  has_many :job_users
  has_many :jobs, through: :job_users

  has_many :user_languages
  has_many :languages, through: :user_languages

  has_many :written_comments, class_name: 'Comment', foreign_key: 'owner_user_id'

  has_many :chat_users
  has_many :chats, through: :chat_users

  has_many :messages, class_name: 'Message', foreign_key: 'author_id'

  validates :language, presence: true
  validates :email, presence: true, uniqueness: true
  validates :name, length: { minimum: 3 }, allow_blank: false
  validates :phone, length: { minimum: 9 }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :address, length: { minimum: 2 }, allow_blank: false

  # FIXME: Verify password!
  def self.find_by_credentials(email:, password:)
    find_by(email: email)
  end

  def self.matches_job(job, distance: 20, strict_match: false)
    lat = job.latitude
    long = job.longitude

    within(lat: lat, long: long, distance: distance).
      order_by_matching_skills(job, strict_match: strict_match)
  end

  # FIXME: Should obviously not be this...
  def admin?
    true
  end

  def reset!
    name = 'Ghost'
    update!(
      anonymized: true,
      name: name,
      email: "#{name}+#{SecureRandom.uuid}@example.com",
      phone: '123456789',
      description: 'This user has been deleted.',
      address: 'New York, NY, USA'
    )
  end
end

# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string
#  email       :string
#  phone       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  latitude    :float
#  longitude   :float
#  address     :string
#  language_id :integer
#  anonymized  :boolean          default(FALSE)
#  auth_token  :string
#
# Indexes
#
#  index_users_on_language_id  (language_id)
#
