# frozen_string_literal: true
class JobSerializer < ApplicationSerializer
  attributes [
    :id, :job_date, :hours, :created_at, :updated_at, :owner_user_id,
    :latitude, :longitude, :language_id, :street, :zip, :zip_latitude, :zip_longitude,
    :hidden, :category_id, :hourly_pay_id, :verified, :job_end_date, :cancelled, :filled,
    :featured, :upcoming, :language_id, :gross_amount, :net_amount, :city, :currency,
    :full_street_address, :staffing_job, :direct_recruitment_job
  ]

  link(:self) { api_v1_job_url(object) }

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

  attribute :translated_text do
    {
      name: object.translated_name,
      short_description: object.translated_short_description,
      description: object.translated_description,
      description_html: to_html(object.translated_description),
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

  has_many :comments, unless: :collection_serializer? do
    link(:related) { api_v1_job_comments_url(job_id: object.id) }

    object.comments.visible
  end

  has_many :job_languages, unless: :collection_serializer?
  has_many :job_skills, unless: :collection_serializer?

  has_one :owner do
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

  has_one :company do
    # Anonymize the company if the job is upcoming
    company_object = if object.upcoming
                       object.company.anonymize
                     else
                       object.company
                     end

    link(:self) do
      api_v1_company_url(company_object) if company_object
    end

    company_object
  end

  has_one :language do
    link(:self) { api_v1_language_url(object.language_id) if object.language_id }
  end

  has_one :category do
    link(:self) { api_v1_category_url(object.category_id) if object.category_id }
  end

  has_one :hourly_pay do
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
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406                   (category_id => categories.id)
#  fk_rails_70cb33aa57                   (language_id => languages.id)
#  fk_rails_b144fc917d                   (hourly_pay_id => hourly_pays.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
