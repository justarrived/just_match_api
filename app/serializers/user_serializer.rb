# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all User column names here
  EXTRA_ATTRIBUTES = %i(ignored_notifications primary_role).freeze
  attributes %i(
    id email phone description created_at updated_at latitude longitude
    language_id anonymized password_hash password_salt admin street city
    zip zip_latitude zip_longitude first_name last_name name ssn banned
    company_id one_time_token one_time_token_expires_at just_arrived_staffing
    ignored_notifications_mask frilans_finans_id frilans_finans_payment_details
    current_status at_und arrived_at country_of_origin managed verified
    account_clearing_number account_number gender full_street_address
    support_chat_activated linkedin_url bank_account facebook_url
    has_welcome_app_account welcome_app_last_checked_at public_profile
  ) + EXTRA_ATTRIBUTES

  link(:self) { api_v1_user_url(object) }

  attribute(:support_chat_activated) { object.support_chat_activated? }
  attribute(:description) { object.original_description }
  attribute(:description_html) { to_html(object.original_description) }

  attribute(:job_experience) { object.original_job_experience }
  attribute(:job_experience_html) { to_html(object.original_job_experience) }

  attribute(:education) { object.original_education }
  attribute(:education_html) { to_html(object.original_education) }

  attribute(:competence_text) { object.original_competence_text }
  attribute(:competence_text_html) { to_html(object.original_competence_text) }

  attribute :translated_text do
    {
      description: object.translated_description,
      description_html: to_html(object.description),
      job_experience: object.translated_job_experience,
      job_experience_html: to_html(object.job_experience),
      education: object.translated_education,
      education_html: to_html(object.education),
      competence_text: object.translated_competence_text,
      competence_text_html: to_html(object.competence_text),
      language_id: object.translated_language_id
    }
  end

  belongs_to :company do
    link(:self) { api_v1_company_url(object.company) if object.company }
  end

  belongs_to :language do
    link(:self) { api_v1_language_url(object.language_id) if object.language_id }
  end

  belongs_to :system_language do
    link(:self) do
      api_v1_language_url(object.system_language_id) if object.system_language_id
    end
  end

  has_many :user_images

  has_many :languages do
    link(:related) { api_v1_user_languages_url(object.id) }
  end

  has_many :user_languages do
    link(:related) { api_v1_user_languages_url(object.id) }

    object.user_languages.visible
  end

  has_many :occupations do
    link(:related) { api_v1_user_occupations_url(object.id) }
  end

  has_many :user_occupations do
    link(:related) { api_v1_user_occupations_url(object.id) }

    object.user_occupations
  end

  has_many :user_documents, unless: :collection_serializer? do
    link(:related) { api_v1_user_documents_url(object.id) }

    object.user_documents.order(created_at: :desc)
  end

  has_many :chats, unless: :collection_serializer? do
    link(:related) { api_v1_user_chats_url(object.id) }
  end

  has_many :skills, unless: :collection_serializer? do
    link(:related) { api_v1_user_skills_url(object.id) }

    object.skills.visible
  end

  has_many :user_skills, unless: :collection_serializer? do
    link(:related) { api_v1_user_skills_url(object.id) }

    object.user_skills.visible
  end

  has_many :interests, unless: :collection_serializer? do
    link(:related) { api_v1_user_interests_url(object.id) }

    object.interests.visible
  end

  has_many :user_interests, unless: :collection_serializer? do
    link(:related) { api_v1_user_interests_url(object.id) }

    object.user_interests.visible
  end

  def attributes(_)
    data = super

    data.slice(*policy.present_attributes(collection: collection_serializer?))
  end

  private

  def policy
    @_user_policy ||= UserPolicy.new(scope.fetch(:current_user), object)
  end
end

# == Schema Information
#
# Table name: users
#
#  account_clearing_number          :string
#  account_number                   :string
#  admin                            :boolean          default(FALSE)
#  anonymization_requested_at       :datetime
#  anonymized_at                    :datetime
#  arbetsformedlingen_registered_at :date
#  arrived_at                       :date
#  at_und                           :integer
#  banned                           :boolean          default(FALSE)
#  city                             :string
#  company_id                       :integer
#  competence_text                  :text
#  country_of_origin                :string
#  created_at                       :datetime         not null
#  current_status                   :integer
#  description                      :text
#  education                        :text
#  email                            :string
#  first_name                       :string
#  frilans_finans_id                :integer
#  frilans_finans_payment_details   :boolean          default(FALSE)
#  gender                           :integer
#  id                               :integer          not null, primary key
#  ignored_notifications_mask       :integer
#  job_experience                   :text
#  just_arrived_staffing            :boolean          default(FALSE)
#  language_id                      :integer
#  last_name                        :string
#  latitude                         :float
#  linkedin_url                     :string
#  longitude                        :float
#  managed                          :boolean          default(FALSE)
#  next_of_kin_name                 :string
#  next_of_kin_phone                :string
#  one_time_token                   :string
#  one_time_token_expires_at        :datetime
#  password_hash                    :string
#  password_salt                    :string
#  phone                            :string
#  presentation_availability        :text
#  presentation_personality         :text
#  presentation_profile             :text
#  ssn                              :string
#  street                           :string
#  super_admin                      :boolean          default(FALSE)
#  system_language_id               :integer
#  updated_at                       :datetime         not null
#  zip                              :string
#  zip_latitude                     :float
#  zip_longitude                    :float
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
#  fk_rails_...                 (company_id => companies.id)
#  fk_rails_...                 (language_id => languages.id)
#  users_system_language_id_fk  (system_language_id => languages.id)
#
