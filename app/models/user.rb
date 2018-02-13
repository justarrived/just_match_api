# frozen_string_literal: true

class User < ApplicationRecord
  include Geocodable
  include SkillMatchable

  class MissingFrilansFinansIdError < RuntimeError; end

  MIN_PASSWORD_LENGTH = AppConfig.min_password_length
  MAX_PASSWORD_LENGTH = AppConfig.max_password_length
  ONE_TIME_TOKEN_VALID_FOR_HOURS = AppConfig.user_one_time_token_valid_for_hours
  DAYS_BETWEEN_WELCOME_CHECKS = AppConfig.days_between_welcome_checks

  LOCATE_BY = {
    address: { lat: :latitude, long: :longitude }.freeze
  }.freeze

  STATUSES = {
    asylum_seeker: 1,
    permanent_residence: 2,
    temporary_residence: 3,
    student_visa: 4,
    eu_citizen: 5
  }.freeze

  AT_UND = {
    yes: 1,
    no: 2
  }.freeze

  GENDER = {
    female: 1,
    male: 2,
    other: 3
  }.freeze

  before_validation :set_normalized_fields

  before_save :encrypt_password

  belongs_to :system_language, class_name: 'Language', foreign_key: 'system_language_id'
  belongs_to :language, optional: true
  belongs_to :company, optional: true
  belongs_to :interviewed_by, optional: true, class_name: 'User', foreign_key: 'interviewed_by_user_id' # rubocop:disable Metrics/LineLength

  has_one :utalk_code, dependent: :nullify

  has_one :digest_subscriber, dependent: :destroy
  has_many :job_digests, through: :digest_subscriber

  has_many :employment_periods

  has_many :feedbacks, dependent: :destroy

  has_many :filter_users, dependent: :destroy
  has_many :filters, through: :filter_users

  has_many :user_documents, dependent: :destroy
  has_many :documents, through: :user_documents

  has_many :user_occupations, dependent: :destroy
  has_many :occupations, through: :user_occupations

  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags

  has_many :auth_tokens, class_name: 'Token', dependent: :destroy

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :owned_jobs, class_name: 'Job', foreign_key: 'owner_user_id', dependent: :restrict_with_error # rubocop:disable Metrics/LineLength

  has_many :job_users, dependent: :restrict_with_error
  has_many :jobs, through: :job_users
  has_many :employed_for_jobs, lambda {
    joins(:job_users).where('job_users.will_perform = true').distinct
  }, through: :job_users, source: :job

  has_many :user_languages, dependent: :destroy
  has_many :languages, through: :user_languages

  has_many :written_comments, class_name: 'Comment', foreign_key: 'owner_user_id', dependent: :destroy # rubocop:disable Metrics/LineLength

  has_many :chat_users, dependent: :destroy
  has_many :chats, through: :chat_users

  has_many :messages, class_name: 'Message', foreign_key: 'author_id', dependent: :destroy

  has_many :user_images, dependent: :destroy

  has_many :given_ratings, class_name: 'Rating', foreign_key: 'from_user_id', dependent: :destroy # rubocop:disable Metrics/LineLength
  has_many :received_ratings, class_name: 'Rating', foreign_key: 'to_user_id', dependent: :destroy # rubocop:disable Metrics/LineLength

  can_count :job_users

  validates :system_language, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :first_name, length: { minimum: 1 }, allow_blank: false
  validates :last_name, length: { minimum: 2 }, allow_blank: false
  validates :phone, length: { minimum: 9 }, uniqueness: true, allow_blank: true
  validates :street, length: { minimum: 2 }, allow_blank: true
  validates :zip, length: { minimum: 5 }, allow_blank: true
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH, maximum: MAX_PASSWORD_LENGTH }, allow_blank: false, on: :create # rubocop:disable Metrics/LineLength
  validates :ssn, uniqueness: true, allow_blank: true
  validates :frilans_finans_id, uniqueness: true, allow_nil: true
  validates :country_of_origin, inclusion: { in: ISO3166::Country.translations.keys }, allow_blank: true # rubocop:disable Metrics/LineLength
  validates :linkedin_url, linkedin: true
  validates :facebook_url, facebook: true

  validate :validate_arrived_at_date
  validate :validate_language_id_in_available_locale
  validate :validate_format_of_phone_number
  validate :validate_swedish_phone_number
  validate :validate_swedish_ssn
  validate :validate_swedish_bank_account
  validate :validate_arrival_date_in_past

  scope :scope_for, (->(user) { user.admin? ? all : where(id: user&.id) })
  scope :sales_users, (-> { admins })
  scope :delivery_users, (-> { super_admins })
  scope :super_admins, (-> { where(super_admin: true) })
  scope :admins, (-> { where(admin: true) })
  scope :company_users, (-> { where.not(company: nil) })
  scope :regular_users, (-> { where(company: nil) })
  scope :managed_users, (-> { where(managed: true) })
  scope :visible, (-> { where.not(banned: true) })
  scope :valid_one_time_tokens, (lambda {
    where('one_time_token_expires_at > ?', Time.zone.now)
  })
  scope :frilans_finans_users, (-> { where.not(frilans_finans_id: nil) })
  scope :needs_frilans_finans_id, (lambda {
    not_anonymized.
      regular_users.
      where(frilans_finans_id: nil).
      where.not(phone: [nil, '']).
      left_joins(:job_users).
      where('job_users.id IS NOT NULL AND job_users.will_perform = true').
      distinct
  })
  scope :anonymized, (-> { where(anonymized: true) })
  scope :not_anonymized, (-> { where(anonymized: false) })
  scope :verified, (-> { where(verified: true) })
  scope :needs_welcome_app_update, (lambda {
    scope = regular_users.where(welcome_app_last_checked_at: nil).
            or(before(:welcome_app_last_checked_at, DAYS_BETWEEN_WELCOME_CHECKS.days.ago))

    scope.where(has_welcome_app_account: false)
  })

  # NOTE: Figure out a good way to validate :current_status, :at_und and :gender
  #       see https://github.com/rails/rails/issues/13971
  enum current_status: STATUSES
  enum at_und: AT_UND
  enum gender: GENDER

  attr_accessor :password

  attr_reader :consent

  include Translatable
  translates :description, :job_experience, :education, :competence_text

  # NOTE: This is necessary for nested activeadmin has_many form
  accepts_nested_attributes_for :user_skills, :user_languages, :user_interests,
                                :user_documents, :user_occupations, :feedbacks,
                                :employment_periods
  accepts_nested_attributes_for :user_tags, allow_destroy: true

  NOTIFICATIONS = UserNotification.names

  ransacker :first_name, type: :string do
    Arel.sql('unaccent("first_name")')
  end

  ransacker :last_name, type: :string do
    Arel.sql('unaccent("last_name")')
  end

  ransacker :city, type: :string do
    Arel.sql('unaccent("city")')
  end

  def self.main_support_user
    find_by(email: AppConfig.support_email) || admins.first
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:near_address]
  end

  def self.find_by_one_time_token(token)
    valid_one_time_tokens.find_by(one_time_token: token)
  end

  def self.find_by_credentials(email_or_phone:, password:)
    user = find_by_email_or_phone(email_or_phone)

    return if user.nil?
    return unless correct_password?(user, password)

    user
  end

  def self.find_token(auth_token)
    Token.not_expired.find_by(token: auth_token)
  end

  def self.find_by_auth_token(auth_token)
    find_token(auth_token)&.user
  end

  def self.find_by_phone(phone, normalize: false)
    phone_number = phone
    if normalize
      phone_number = PhoneNumber.normalize(phone_number)
      return if phone_number.nil? # The phone number format is invalid
    end

    find_by(phone: phone_number)
  end

  def self.find_by_email_or_phone(email_or_phone)
    return if email_or_phone.blank?

    email = email_or_phone.downcase
    phone = email_or_phone
    find_by(email: email) || find_by_phone(phone, normalize: true)
  end

  def self.correct_password?(user, password)
    password_hash = BCrypt::Engine.hash_secret(password, user.password_salt)
    user.password_hash.eql?(password_hash)
  end

  def self.wrong_password?(user, password)
    !correct_password?(user, password)
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

  def support_chat_activated?
    verified || super_admin || admin || just_arrived_staffing
  end

  def all_attributes
    attributes.merge(virtual_attributes)
  end

  def virtual_attributes
    { 'bank_account' => bank_account }
  end

  def bank_account_details?
    return false if account_clearing_number.blank?
    return false if account_number.blank?

    true
  end

  def contact_email
    return email unless managed

    ManagedEmailAddress.call(email: email, id: "user#{id}")
  end

  def anonymize
    assign_attributes(
      id: -1,
      anonymized: true,
      first_name: 'Anonymous',
      last_name: 'User',
      email: 'anonymous@example.com',
      description: 'This user is anonymous.',
      street: 'XYZXYZ XX',
      zip: 'XYZX YZ',
      ssn: 'XYZXYZXYZX',
      company: candidate? ? nil : company.anonymize
    )
    self
  end

  def average_score(round: nil)
    received_ratings.average_score(round: round)
  end

  delegate :count, to: :received_ratings, prefix: true

  # ActiveAdmin display name
  def display_name
    "##{id} #{name}"
  end

  def not_persisted?
    !persisted?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin || super_admin
  end

  def super_admin?
    super_admin
  end

  def company?
    company_id.present?
  end

  def candidate?
    primary_role == :candidate
  end

  def phone?
    phone.present?
  end

  def locale
    return I18n.default_locale.to_s if system_language.nil?

    system_language.lang_code
  end

  def frilans_finans_id!
    frilans_finans_id || begin
      fail(MissingFrilansFinansIdError, "User ##{id} has no Frilans Finans id!")
    end
  end

  def primary_role
    if admin?
      :admin
    elsif company_id
      :company
    else
      :candidate
    end
  end

  def auth_token
    auth_tokens.last&.token
  end

  def set_normalized_fields
    set_normalized_phone
    set_normalized_ssn
    set_normalized_email
    set_normalized_bank_account
  end

  def set_normalized_phone
    self.phone = PhoneNumber.normalize(phone)
  end

  def set_normalized_ssn
    self.ssn = SwedishSSN.normalize(ssn)
  end

  def set_normalized_email
    self.email = EmailAddress.normalize(email)
  end

  def bank_account
    return @bank_account if @bank_account
    return unless bank_account_details?

    account_clearing_number + account_number
  end

  def bank_account=(full_account)
    account = SwedishBankAccount.new(full_account)
    @bank_account = full_account # make sure the accessor has access to the "fresh" value
    return unless account.valid?

    # make sure that the accessor can access the "cleaned" value
    @bank_account = account.clearing_number + account.serial_number

    self.account_clearing_number = account.clearing_number
    self.account_number = account.serial_number
  end

  def set_normalized_bank_account
    self.bank_account = bank_account || [account_clearing_number, account_number].join
  end

  # NOTE: This method has unintuitive side effects.. if the banned attribute is
  #   just set to true all associated auth_tokens will immediately be destroyed
  #   We should probably convert this to #banned! which also saves the user
  def banned=(value)
    auth_tokens.destroy_all if value
    self[:banned] = value
  end

  def add_image_by_token=(token)
    return if token.blank?

    user_image = UserImage.find_by_one_time_token(token)
    user_images << user_image if user_image
  end

  def set_images_by_tokens=(tokens)
    return if tokens.blank?

    self.user_images = UserImage.find_by_one_time_tokens(tokens)
  end

  def ignored_notification?(notification)
    ignored_notifications.include?(notification.to_s)
  end

  def ignored_notifications=(notifications)
    mask = BitmaskField.to_mask(notifications, UserNotification.names)
    self.ignored_notifications_mask = mask
  end

  def ignored_notifications
    BitmaskField.from_mask(ignored_notifications_mask, UserNotification.names)
  end

  def anonymize_attributes
    assign_attributes(
      anonymized: true,
      first_name: 'Ghost',
      last_name: 'User',
      email: "ghost+#{SecureGenerator.token(length: 64)}@example.com",
      phone: nil,
      description: 'This user has been deleted.',
      street: nil,
      ssn: nil
    )
  end

  def reset!
    # Update the users attributes and don't validate
    anonymize_attributes
    save!(validate: false)
  end

  def create_auth_token
    token = Token.new
    auth_tokens << token
    token
  end

  def generate_one_time_token(valid_duration: ONE_TIME_TOKEN_VALID_FOR_HOURS.hours)
    self.one_time_token_expires_at = Time.zone.now + valid_duration
    self.one_time_token = SecureGenerator.token
  end

  def self.valid_password_format?(password)
    return false if password.blank?
    return false unless password.is_a?(String)

    # BCrypt implementations will allow for at least 50 chars, but after that its not
    # guaranteed, see https://security.stackexchange.com/questions/39849/does-bcrypt-have-a-maximum-password-length
    password.length >= MIN_PASSWORD_LENGTH && password.length <= MAX_PASSWORD_LENGTH
  end

  def country_name
    'Sweden'
  end

  def validate_arrival_date_in_past
    return if arrived_at.blank? || arrived_at <= Time.zone.today

    error_message = I18n.t('errors.user.arrived_at_must_be_in_past')
    errors.add(:arrived_at, error_message)
  end

  def validate_language_id_in_available_locale
    return unless system_language_id_changed?
    return if system_language_id.blank?

    unless I18n.available_locales.map(&:to_s).include?(system_language.lang_code)
      errors.add(:system_language_id, I18n.t('errors.user.must_be_available_locale'))
    end
  end

  def validate_format_of_phone_number
    return if phone.blank?
    return if PhoneNumber.valid?(phone)

    error_message = I18n.t('errors.user.must_be_valid_phone_number_format')
    errors.add(:phone, error_message)
  end

  def validate_swedish_phone_number
    return if phone.blank?
    return if PhoneNumber.swedish_number?(phone)

    error_message = I18n.t('errors.user.must_be_swedish_phone_number')
    errors.add(:phone, error_message)
  end

  def validate_swedish_ssn
    return unless Rails.configuration.x.validate_swedish_ssn
    return if ssn.blank?
    return if SwedishSSN.valid?(ssn)

    error_message = I18n.t('errors.user.must_be_swedish_ssn')
    errors.add(:ssn, error_message)
  end

  def validate_swedish_bank_account
    return if bank_account.blank?

    SwedishBankAccount.new(bank_account).tap do |account|
      account.errors_by_field do |_field, error_types|
        error_types.each do |type|
          errors.add(:bank_account, I18n.t("errors.bank_account.#{type}"))
        end
      end
    end
  end

  def validate_arrived_at_date
    arrived_at_before_cast = read_attribute_before_type_cast(:arrived_at)
    return if arrived_at_before_cast.blank?
    return if arrived_at.present?

    error_message = I18n.t('errors.general.must_be_valid_date')
    errors.add(:arrived_at, error_message)
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
#  id                               :integer          not null, primary key
#  email                            :string
#  phone                            :string
#  description                      :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  latitude                         :float
#  longitude                        :float
#  language_id                      :integer
#  anonymized                       :boolean          default(FALSE)
#  password_hash                    :string
#  password_salt                    :string
#  admin                            :boolean          default(FALSE)
#  street                           :string
#  zip                              :string
#  zip_latitude                     :float
#  zip_longitude                    :float
#  first_name                       :string
#  last_name                        :string
#  ssn                              :string
#  company_id                       :integer
#  banned                           :boolean          default(FALSE)
#  job_experience                   :text
#  education                        :text
#  one_time_token                   :string
#  one_time_token_expires_at        :datetime
#  ignored_notifications_mask       :integer
#  frilans_finans_id                :integer
#  frilans_finans_payment_details   :boolean          default(FALSE)
#  competence_text                  :text
#  current_status                   :integer
#  at_und                           :integer
#  arrived_at                       :date
#  country_of_origin                :string
#  managed                          :boolean          default(FALSE)
#  account_clearing_number          :string
#  account_number                   :string
#  verified                         :boolean          default(FALSE)
#  skype_username                   :string
#  interview_comment                :text
#  next_of_kin_name                 :string
#  next_of_kin_phone                :string
#  arbetsformedlingen_registered_at :date
#  city                             :string
#  interviewed_by_user_id           :integer
#  interviewed_at                   :datetime
#  just_arrived_staffing            :boolean          default(FALSE)
#  super_admin                      :boolean          default(FALSE)
#  gender                           :integer
#  presentation_profile             :text
#  presentation_personality         :text
#  presentation_availability        :text
#  system_language_id               :integer
#  linkedin_url                     :string
#  facebook_url                     :string
#  has_welcome_app_account          :boolean          default(FALSE)
#  welcome_app_last_checked_at      :datetime
#  public_profile                   :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_company_id          (company_id)
#  index_users_on_email               (email) UNIQUE
#  index_users_on_frilans_finans_id   (frilans_finans_id) UNIQUE
#  index_users_on_language_id         (language_id)
#  index_users_on_one_time_token      (one_time_token) UNIQUE
#  index_users_on_system_language_id  (system_language_id)
#
# Foreign Keys
#
#  fk_rails_...                     (company_id => companies.id)
#  fk_rails_...                     (language_id => languages.id)
#  users_interviewed_by_user_id_fk  (interviewed_by_user_id => users.id)
#  users_system_language_id_fk      (system_language_id => languages.id)
#
