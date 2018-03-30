# frozen_string_literal: true

class JobSerializer < ApplicationSerializer
  attributes %i(
    id job_date hours created_at updated_at owner_user_id
    latitude longitude language_id street zip zip_latitude zip_longitude
    hidden category_id hourly_pay_id verified job_end_date cancelled filled
    featured upcoming language_id gross_amount net_amount city currency
    full_street_address direct_recruitment_job application_url
    swedish_drivers_license car_required last_application_at full_time publish_at
    unpublish_at
  )

  link(:self) { api_v1_job_url(object) }

  attribute :staffing_job do
    object.staffing_company_id.present?
  end

  attribute :frilans_finans_job do
    object.frilans_finans_job?
  end

  attribute :name do
    object.original_name
  end

  attribute :short_description do
    object.original_short_description
  end

  attribute :description do
    object.original_description
  end

  attribute :description_html do
    to_html(object.original_description)
  end

  attribute :tasks_description do
    object.original_tasks_description
  end

  attribute :tasks_description_html do
    to_html(object.original_tasks_description)
  end

  attribute :applicant_description do
    object.original_applicant_description
  end

  attribute :applicant_description_html do
    to_html(object.original_applicant_description)
  end

  attribute :requirements_description do
    object.original_requirements_description
  end

  attribute :requirements_description_html do
    to_html(object.original_requirements_description)
  end

  attribute :translated_text do
    {
      name: object.translated_name,
      short_description: object.translated_short_description,
      description: object.translated_description,
      description_html: to_html(object.translated_description),
      tasks_description: object.translated_tasks_description,
      tasks_description_html: to_html(object.translated_tasks_description),
      applicant_description: object.translated_applicant_description,
      applicant_description_html: to_html(object.translated_applicant_description),
      requirements_description: object.translated_requirements_description,
      requirements_description_html: to_html(object.translated_requirements_description),
      language_id: object.translated_language_id
    }
  end

  attribute :gross_amount_delimited do
    to_delimited(object.gross_amount)
  end

  attribute :net_amount_delimited do
    to_delimited(object.net_amount)
  end

  attribute :gross_amount_with_currency do
    to_unit(object.gross_amount, object.currency)
  end

  attribute :net_amount_with_currency do
    to_unit(object.net_amount, object.currency)
  end

  attribute :last_application_at_in_words do
    distance_of_time_in_words_from_now(object.last_application_at)
  end

  attribute :open_for_applications do
    object.open_for_applications?
  end

  attribute :starts_in_the_future do
    object.dates_object.starts_in_the_future?
  end

  attribute :schema_org, unless: :collection_serializer? do
    {
      job_position: SchemaOrg::JobPosting.new(
        job: object,
        company: object.company,
        main_occupation: object.occupations.first || Occupation.new
      ).to_h
    }
  end

  has_many :comments, unless: :collection_serializer? do
    link(:related) { api_v1_job_comments_url(job_id: object.id) }

    object.comments.visible
  end

  has_many :job_languages, unless: :collection_serializer?
  has_many :job_skills, unless: :collection_serializer?
  has_many :job_occupations, unless: :collection_serializer?

  belongs_to(:responsible_recruiter) { object.just_arrived_contact }

  belongs_to :owner do
    owner_object = if object.upcoming
                     object.owner.anonymize
                   else
                     object.owner
                   end

    link(:self) do
      api_v1_user_url(owner_object) if owner_object
    end

    owner_object
  end

  belongs_to :company do
    # Anonymize the company if the job is upcoming
    company_object = if object.upcoming
                       object.company&.anonymize
                     else
                       object.company
                     end

    link(:self) do
      api_v1_company_url(company_object) if company_object
    end

    company_object
  end

  belongs_to :language do
    link(:self) { api_v1_language_url(object.language_id) if object.language_id }
  end

  belongs_to :category do
    link(:self) { api_v1_category_url(object.category_id) if object.category_id }
  end

  belongs_to :hourly_pay do
    link(:self) { api_v1_hourly_pay_url(object.hourly_pay_id) if object.hourly_pay_id }
  end

  def attributes(_)
    data = super

    data.slice(*policy.present_attributes(collection: collection_serializer?))
  end

  private

  def policy
    @_job_policy ||= JobPolicy.new(scope.fetch(:current_user), object)
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
#  short_description            :string
#  featured                     :boolean          default(FALSE)
#  upcoming                     :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  just_arrived_contact_user_id :integer
#  city                         :string
#  staffing_job                 :boolean          default(FALSE)
#  direct_recruitment_job       :boolean          default(FALSE)
#  order_id                     :integer
#  municipality                 :string
#  number_to_fill               :integer          default(1)
#  full_time                    :boolean          default(FALSE)
#  swedish_drivers_license      :string
#  car_required                 :boolean          default(FALSE)
#  salary_type                  :integer          default("fixed")
#  publish_on_linkedin          :boolean          default(FALSE)
#  publish_on_blocketjobb       :boolean          default(FALSE)
#  last_application_at          :datetime
#  blocketjobb_category         :string
#  publish_at                   :datetime
#  unpublish_at                 :datetime
#  tasks_description            :text
#  applicant_description        :text
#  requirements_description     :text
#  preview_key                  :string
#  customer_hourly_price        :decimal(, )
#  invoice_comment              :text
#  publish_on_metrojobb         :boolean          default(FALSE)
#  metrojobb_category           :string
#  staffing_company_id          :integer
#  cloned                       :boolean          default(FALSE)
#  filled_at                    :datetime
#
# Indexes
#
#  index_jobs_on_category_id          (category_id)
#  index_jobs_on_hourly_pay_id        (hourly_pay_id)
#  index_jobs_on_language_id          (language_id)
#  index_jobs_on_order_id             (order_id)
#  index_jobs_on_staffing_company_id  (staffing_company_id)
#
# Foreign Keys
#
#  fk_rails_...                          (category_id => categories.id)
#  fk_rails_...                          (hourly_pay_id => hourly_pays.id)
#  fk_rails_...                          (language_id => languages.id)
#  fk_rails_...                          (order_id => orders.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
