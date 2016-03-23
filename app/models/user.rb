# frozen_string_literal: true
class User < ActiveRecord::Base
  include Geocodable
  include SkillMatchable

  MIN_PASSWORD_LENGTH = 6
  ONE_TIME_TOKEN_VALID_FOR_HOURS = 18

  LOCATE_BY = {
    address: { lat: :latitude, long: :longitude }
  }.freeze

  attr_accessor :password

  before_create :generate_auth_token
  before_save :encrypt_password

  belongs_to :language
  belongs_to :company

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
  validates :first_name, length: { minimum: 2 }, allow_blank: false
  validates :last_name, length: { minimum: 2 }, allow_blank: false
  validates :phone, length: { minimum: 9 }, allow_blank: false
  validates :description, length: { minimum: 10 }, allow_blank: false
  validates :street, length: { minimum: 5 }, allow_blank: false
  validates :zip, length: { minimum: 5 }, allow_blank: false
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH }, allow_blank: false, on: :create # rubocop:disable Metrics/LineLength
  validates :auth_token, uniqueness: true
  validates :ssn, uniqueness: true, length: { is: 10 }, allow_blank: false

  scope :admins, -> { where(admin: true) }
  scope :company_users, -> { where.not(company: nil) }
  scope :visible, -> { where.not(banned: true) }

  def self.find_by_one_time_token(token)
    where('one_time_token_expires_at > ?', Time.zone.now).
      find_by(one_time_token: token)
  end

  def self.find_by_credentials(email:, password:)
    user = find_by(email: email) || return
    user if correct_password?(user, password)
  end

  def self.correct_password?(user, password)
    password_hash = BCrypt::Engine.hash_secret(password, user.password_salt)
    user.password_hash.eql?(password_hash)
  end

  def self.matches_job(job, distance: 20, strict_match: false)
    lat = job.latitude
    long = job.longitude

    within(lat: lat, long: long, distance: distance).
      order_by_matching_skills(job, strict_match: strict_match)
  end

  def self.accepted_applicant_for_owner?(owner:, user:)
    jobs = owner.owned_jobs & JobUser.accepted_jobs_for(user)
    jobs.any?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin
  end

  def banned=(value)
    generate_auth_token if value
    self[:banned] = value
  end

  def reset!
    update!(
      anonymized: true,
      first_name: 'Ghost',
      last_name: 'user',
      email: "ghost+#{SecureRandom.uuid}@example.com",
      phone: '123456789',
      description: 'This user has been deleted.',
      street: 'Stockholm',
      zip: '11120',
      ssn: '0000000000'
    )
  end

  def generate_auth_token
    self.auth_token = SecureRandom.uuid
  end

  def generate_one_time_token
    self.one_time_token_expires_at = Time.zone.now + ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
    self.one_time_token = SecureRandom.uuid
  end

  def self.valid_password?(password)
    return false if password.blank?
    return false unless password.is_a?(String)

    password.length >= 6
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string
#  phone                     :string
#  description               :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  latitude                  :float
#  longitude                 :float
#  language_id               :integer
#  anonymized                :boolean          default(FALSE)
#  auth_token                :string
#  password_hash             :string
#  password_salt             :string
#  admin                     :boolean          default(FALSE)
#  street                    :string
#  zip                       :string
#  zip_latitude              :float
#  zip_longitude             :float
#  first_name                :string
#  last_name                 :string
#  ssn                       :string
#  company_id                :integer
#  banned                    :boolean          default(FALSE)
#  job_experience            :text
#  education                 :text
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#
# Indexes
#
#  index_users_on_auth_token      (auth_token) UNIQUE
#  index_users_on_company_id      (company_id)
#  index_users_on_email           (email) UNIQUE
#  index_users_on_language_id     (language_id)
#  index_users_on_one_time_token  (one_time_token) UNIQUE
#  index_users_on_ssn             (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
