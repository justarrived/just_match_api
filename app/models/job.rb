# frozen_string_literal: true

class Job < ApplicationRecord
  include Geocodable
  include SkillMatchable

  LOCATE_BY = {
    address: { lat: :latitude, long: :longitude },
    zip: { lat: :zip_latitude, long: :zip_longitude }
  }.freeze

  SALARY_TYPES = {
    fixed: 1,
    fixed_and_commission: 2,
    commission: 3
  }.freeze

  MIN_TOTAL_HOURS = 2
  MIN_HOURS_PER_DAY = 0.5
  MAX_HOURS_PER_DAY = 12

  belongs_to :order, optional: true
  belongs_to :language, optional: true
  belongs_to :category
  belongs_to :hourly_pay
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'
  # rubocop:disable Metrics/LineLength
  belongs_to :company_contact, class_name: 'User', foreign_key: 'company_contact_user_id', optional: true
  belongs_to :just_arrived_contact, class_name: 'User', foreign_key: 'just_arrived_contact_user_id', optional: true
  # rubocop:enable Metrics/LineLength

  has_one :company, through: :owner
  has_one :arbetsformedlingen_ad

  has_many :job_skills
  has_many :skills, through: :job_skills

  has_many :job_languages
  has_many :languages, through: :job_languages

  has_many :job_users
  has_many :users, through: :job_users

  has_many :comments, as: :commentable

  before_validation :set_normalized_swedish_drivers_license

  validates :hourly_pay, presence: true
  validates :category, presence: true
  validates :name, presence: true, on: :create # Virtual attribute
  validates :description, presence: true, on: :create # Virtual attribute
  validates :street, length: { minimum: 3 }, allow_blank: false
  validates :city, length: { minimum: 2 }, allow_blank: true
  validates :zip, length: { minimum: 5 }, allow_blank: false
  validates :municipality, swedish_municipality: true
  validates :swedish_drivers_license, swedish_drivers_license: true
  validates :job_date, presence: true
  validates :owner, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: MIN_TOTAL_HOURS }, presence: true # rubocop:disable Metrics/LineLength
  validates :number_to_fill, numericality: { greater_than_or_equal_to: 1 }
  validates :blocketjobb_category, inclusion: BlocketjobbCategories.to_a, allow_nil: true, if: :publish_on_blocketjobb # rubocop:disable Metrics/LineLength

  validate :validate_job_end_date_after_job_date
  validate :validate_last_application_at_on_publish_to_blocketjobb
  validate :validate_municipality_presence_on_publish_to_blocketjobb
  validate :validate_blocketjobb_category_presence_on_publish_to_blocketjobb
  validate :validate_company_presence_on_publish_to_blocketjobb
  validate :validate_hourly_pay_active
  validate :validate_within_allowed_hours
  validate :validate_owner_belongs_to_company, unless: -> { AppConfig.allow_regular_users_to_create_jobs? } # rubocop:disable Metrics/LineLength

  validate :validate_job_date_in_future, unless: -> { Rails.configuration.x.validate_job_date_in_future_inactive } # rubocop:disable Metrics/LineLength

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
  scope :active_between, lambda { |from, to|
    between = between(:job_date, from, to).or(between(:job_end_date, from, to))
    outer_between = where('job_date <= ? AND job_end_date >= ?', from, to)

    between.or(outer_between).uncancelled.filled
  }
  scope :ongoing, lambda {
    today = Time.zone.today
    active_between(today.beginning_of_day, today.end_of_day)
  }
  scope :order_by_name, lambda { |direction: :asc|
    dir = direction.to_s == 'desc' ? 'DESC' : 'ASC'
    order("job_translations.name #{dir}")
  }
  scope :passed, -> { where('job_end_date < ?', Time.zone.now) }
  scope :future, -> { where('job_end_date > ?', Time.zone.now) }
  scope :linkedin_jobs, -> { where(publish_on_linkedin: true) }
  scope :blocketjobb_jobs, -> { where(publish_on_blocketjobb: true) }

  enum salary_type: SALARY_TYPES

  include Translatable
  translates :name, :short_description, :description

  # NOTE: This is necessary for nested activeadmin has_many form
  accepts_nested_attributes_for :job_skills, :job_languages

  ransacker :city, type: :string do
    Arel.sql("unaccent(\"city\")")
  end

  ransacker :municipality, type: :string do
    Arel.sql("unaccent(\"city\")")
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:near_address]
  end

  delegate :currency, to: :hourly_pay
  delegate :ssyk, to: :category

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

  def self.to_form_array(include_blank: false)
    form_array = with_translations.
                 order(id: :desc).
                 map { |job| [job.display_name, job.id] }

    return form_array unless include_blank

    [[I18n.t('admin.form.no_job_chosen'), nil]] + form_array
  end

  def set_normalized_swedish_drivers_license
    value = Arbetsformedlingen::DriversLicenseCode.normalize(swedish_drivers_license)
    self.swedish_drivers_license = value
  end

  def application_url
    FrontendRouter.draw(:job, id: id)
  end

  def profession_title
    category&.name
  end

  def schedule_summary
    I18n.t('job.schedule_summary', start_date: job_date.to_date)
  end

  def salary_summary
    I18n.t(
      'job.salary_summary',
      hourly_gross_salary_with_unit: hourly_pay.gross_salary_with_unit
    )
  end

  def frilans_finans_job?
    !staffing_job && !direct_recruitment_job
  end

  def started?
    job_date < Time.zone.now
  end

  def ended?
    return false unless job_end_date

    job_end_date < Time.zone.now
  end

  def address
    full_street_address # From the Geocodable module
  end

  # ActiveAdmin display name
  def display_name
    "##{id} #{original_name}"
  end

  def report_name
    "#{name} (##{id})"
  end

  def invoice_specification
    <<-JOB_SPECIFICATION
#{name} (ID: ##{id}) - #{profession_title}

Period: #{job_date.to_date} - #{job_end_date.to_date}
Total hours: #{hours}

Hourly invoice: #{hourly_pay.invoice_rate} SEK/h
Gross salary: #{hourly_pay.gross_salary} SEK/h

COMPANY
#{company.name} (ID: ##{company.id})
CIN (Org. No.): #{company.cin}
Billing email: #{company.billing_email}
Address: #{company.address}
    JOB_SPECIFICATION
  end

  def invoice_company_frilans_finans_id
    ff_id = Rails.configuration.x.invoice_company_frilans_finans_id
    return owner.company.frilans_finans_id if ff_id.nil?

    Integer(ff_id)
  end

  def country_code
    'SE'
  end

  def company?
    company.present?
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

  def gross_amount
    hourly_pay.gross_salary * hours
  end

  def net_amount
    hourly_pay.net_salary * hours
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

  def hourly_gross_salary
    hourly_pay.gross_salary
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
      location: address,
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

  def validate_last_application_at_on_publish_to_blocketjobb
    return unless publish_on_blocketjobb
    return if last_application_at.present?

    message = I18n.t('errors.job.last_application_at_on_publish_to_blocketjobb')
    errors.add(:last_application_at, message)
  end

  def validate_municipality_presence_on_publish_to_blocketjobb
    return unless publish_on_blocketjobb
    return if municipality.present?

    message = I18n.t('errors.job.municipality_presence_on_publish_to_blocketjobb')
    errors.add(:municipality, message)
  end

  def validate_blocketjobb_category_presence_on_publish_to_blocketjobb
    return unless publish_on_blocketjobb
    return if blocketjobb_category.present?

    message = I18n.t('errors.job.blocketjobb_category_presence_on_publish_to_blocketjobb')
    errors.add(:blocketjobb_category, message)
  end

  def validate_company_presence_on_publish_to_blocketjobb
    return unless publish_on_blocketjobb
    return if company.present?

    message = I18n.t('errors.job.company_presence_on_publish_to_blocketjobb')
    errors.add(:company, message)
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

  def validate_owner_belongs_to_company
    return if owner.nil?
    return if owner.company?

    errors.add(:owner, I18n.t('errors.job.owner_must_belong_to_company'))
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                           :integer          not null, primary key
#  description                  :text
#  job_date                     :datetime
#  hours                        :float
#  name                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  owner_user_id                :integer
#  latitude                     :float
#  longitude                    :float
#  language_id                  :integer
#  street                       :string
#  zip                          :string
#  zip_latitude                 :float
#  zip_longitude                :float
#  hidden                       :boolean          default(FALSE)
#  category_id                  :integer
#  hourly_pay_id                :integer
#  verified                     :boolean          default(FALSE)
#  job_end_date                 :datetime
#  cancelled                    :boolean          default(FALSE)
#  filled                       :boolean          default(FALSE)
#  short_description            :string
#  featured                     :boolean          default(FALSE)
#  upcoming                     :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  just_arrived_contact_user_id :integer
#  city                         :string
#  staffing_job                 :boolean          default(FALSE)
#  direct_recruitment_job       :boolean          default(FALSE)
#  municipality                 :string
#  number_to_fill               :integer          default(1)
#  order_id                     :integer
#  full_time                    :boolean          default(FALSE)
#  swedish_drivers_license      :string
#  car_required                 :boolean          default(FALSE)
#  salary_type                  :integer          default("fixed")
#  publish_on_linkedin          :boolean          default(FALSE)
#  publish_on_blocketjobb       :boolean          default(FALSE)
#  last_application_at          :datetime
#  blocketjobb_category         :string
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#  index_jobs_on_order_id       (order_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406                   (category_id => categories.id)
#  fk_rails_70cb33aa57                   (language_id => languages.id)
#  fk_rails_b144fc917d                   (hourly_pay_id => hourly_pays.id)
#  fk_rails_ca13181750                   (order_id => orders.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
