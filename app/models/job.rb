# frozen_string_literal: true
class Job < ApplicationRecord
  include Geocodable
  include SkillMatchable

  LOCATE_BY = {
    address: { lat: :latitude, long: :longitude },
    zip: { lat: :zip_latitude, long: :zip_longitude }
  }.freeze

  MIN_TOTAL_HOURS = 2
  MIN_HOURS_PER_DAY = 0.5
  MAX_HOURS_PER_DAY = 12

  belongs_to :language
  belongs_to :category
  belongs_to :hourly_pay

  has_one :company, through: :owner

  has_many :job_skills
  has_many :skills, through: :job_skills

  has_many :job_users
  has_many :users, through: :job_users

  has_many :comments, as: :commentable

  validates :language, presence: true
  validates :hourly_pay, presence: true
  validates :category, presence: true
  validates :name, presence: true, on: :create # Virtual attribute
  validates :description, presence: true, on: :create # Virtual attribute
  validates :street, length: { minimum: 5 }, allow_blank: false
  validates :zip, length: { minimum: 5 }, allow_blank: false
  validates :job_date, presence: true
  validates :job_end_date, presence: true
  validates :owner, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: MIN_TOTAL_HOURS }, allow_blank: false # rubocop:disable Metrics/LineLength

  validate :validate_job_end_date_after_job_date
  validate :validate_hourly_pay_active
  validate :validate_within_allowed_hours

  validate :validate_job_date_in_future, unless: -> { Rails.configuration.x.validate_job_date_in_future_inactive } # rubocop:disable Metrics/LineLength

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'

  scope :visible, -> { where(hidden: false) }
  scope :cancelled, -> { where(cancelled: true) }
  scope :uncancelled, -> { where(cancelled: false) }
  scope :filled, -> { where(filled: true) }
  scope :unfilled, -> { where(filled: false) }
  scope :upcoming, -> { where(upcoming: true) }
  scope :featured, -> { where(featured: true) }
  scope :applied_jobs, lambda { |user_id|
    joins(:job_users).where('job_users.user_id = ?', user_id)
  }
  scope :no_applied_jobs, lambda { |user_id|
    where.not(id: applied_jobs(user_id).map(&:id))
  }

  include Translatable
  translates :name, :short_description, :description

  # This will return an Array and not an ActiveRecord::Relation
  def self.non_hired
    sql = <<-SQL
    SELECT *
    FROM "jobs"
         full OUTER JOIN "job_users"
                      ON "job_users"."job_id" = "jobs"."id"
    WHERE (accepted IS FALSE
              OR job_id IS NULL)
    SQL
    find_by_sql(sql)
  end

  def self.matches_user(user, distance: 20, strict_match: false)
    lat = user.latitude
    long = user.longitude

    within(lat: lat, long: long, distance: distance).
      order_by_matching_skills(user, strict_match: strict_match)
  end

  def self.associated_jobs(user)
    joins('LEFT JOIN job_users ON job_users.job_id = jobs.id').
      where('jobs.owner_user_id = :user OR job_users.user_id = :user', user: user)
  end

  def address
    full_street_address # From the Geocodable module
  end

  def invoice_specification
    <<-JOB_SPECIFICATION
#{name} (ID: ##{id}) - #{category.name}

Period: #{job_date.to_date} - #{job_end_date.to_date}
Total hours: #{hours}

Hourly invoice: #{hourly_pay.invoice_rate} SEK/h
Gross salary: #{hourly_pay.gross_salary} SEK/h

COMPANY
#{company.name} (ID: ##{company.id})
Billing email: #{company.billing_email}
Address: #{company.address}
    JOB_SPECIFICATION
  end

  def invoice_company_frilans_finans_id
    ff_id = Rails.configuration.x.invoice_company_frilans_finans_id
    return owner.company.frilans_finans_id if ff_id.nil?

    Integer(ff_id)
  end

  def position_filled?
    filled
  end

  def fill_position
    update(filled: true)
  end

  def fill_position!
    update!(filled: true)
  end

  def locked_for_changes?
    applicant = applicants.find_by(accepted: true)
    return false unless applicant

    applicant.will_perform
  end

  def amount
    hourly_pay.gross_salary * hours
  end

  def invoice_amount
    hourly_pay.invoice_rate * hours
  end

  # NOTE: You need to call this __before__ the record is validated
  #       otherwise it will always return false
  def send_cancelled_notice?
    cancelled_changed? && cancelled
  end

  def owner?(user)
    !owner.nil? && owner == user
  end

  def find_applicant(user)
    job_users.find_by(user: user)
  end

  def accepted_applicant?(user)
    !accepted_applicant.nil? && accepted_applicant == user
  end

  def accepted_job_user
    applicants.find_by(accepted: true)
  end

  def accepted_applicant
    accepted_job_user&.user
  end

  def accepted_user
    accept_applicant
  end

  def accept_applicant!(user)
    applicants.find_by(user: user).tap do |applicant|
      applicant.accept
      applicant.save!
    end.reload
  end

  def create_applicant!(user)
    users << user
    user
  end

  def applicants
    job_users
  end

  def started?
    job_date < Time.zone.now
  end

  def workdays
    return if job_date.nil? || job_end_date.nil?

    days = DateSupport.days_in(job_date, job_end_date)
    # If the job is less than a week count each day as a work day, otherwise
    # only count weekdays as work days
    return days if days.length <= 7

    DateSupport.weekdays_in(job_date, job_end_date)
  end

  def google_calendar_template_url
    GoogleCalendarUrl.build(
      name: name,
      description: description,
      location: [street, zip].join(', '),
      start_time: job_date,
      end_time: job_end_date
    )
  end

  def validate_job_date_in_future
    return unless job_date_changed?
    return if job_date.nil? || job_date > Time.zone.now

    errors.add(:job_date, I18n.t('errors.job.job_date_in_the_past'))
  end

  def validate_job_end_date_after_job_date
    return if job_date.nil? || job_end_date.nil? || job_end_date >= job_date

    errors.add(:job_end_date, I18n.t('errors.job.job_end_date_after_job_date'))
  end

  def validate_hourly_pay_active
    return if hourly_pay.nil? || hourly_pay.active

    errors.add(:hourly_pay, I18n.t('errors.job.hourly_pay_active'))
  end

  def validate_within_allowed_hours
    return if job_date.nil? || job_end_date.nil? || hours.nil?

    hours_per_day = hours.to_f / workdays.length

    if hours_per_day < MIN_HOURS_PER_DAY
      message = I18n.t('errors.job.hours_lower_bound', min_hours: MIN_HOURS_PER_DAY)
      errors.add(:hours, message)
    end

    if hours_per_day > MAX_HOURS_PER_DAY
      message = I18n.t('errors.job.hours_upper_bound', max_hours: MAX_HOURS_PER_DAY)
      errors.add(:hours, message)
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                :integer          not null, primary key
#  description       :text
#  job_date          :datetime
#  hours             :float
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  owner_user_id     :integer
#  latitude          :float
#  longitude         :float
#  language_id       :integer
#  street            :string
#  zip               :string
#  zip_latitude      :float
#  zip_longitude     :float
#  hidden            :boolean          default(FALSE)
#  category_id       :integer
#  hourly_pay_id     :integer
#  verified          :boolean          default(FALSE)
#  job_end_date      :datetime
#  cancelled         :boolean          default(FALSE)
#  filled            :boolean          default(FALSE)
#  short_description :string
#  featured          :boolean          default(FALSE)
#  upcoming          :boolean          default(FALSE)
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406    (category_id => categories.id)
#  fk_rails_70cb33aa57    (language_id => languages.id)
#  fk_rails_b144fc917d    (hourly_pay_id => hourly_pays.id)
#  jobs_owner_user_id_fk  (owner_user_id => users.id)
#
