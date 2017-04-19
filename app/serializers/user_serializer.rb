# frozen_string_literal: true
class UserSerializer < ApplicationSerializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all User column names here
  EXTRA_ATTRIBUTES = %i(ignored_notifications primary_role).freeze
  attributes [
    :id, :email, :phone, :description, :created_at, :updated_at, :latitude, :longitude,
    :language_id, :anonymized, :password_hash, :password_salt, :admin, :street, :city,
    :zip, :zip_latitude, :zip_longitude, :first_name, :last_name, :name, :ssn, :banned,
    :company_id, :one_time_token, :one_time_token_expires_at, :just_arrived_staffing,
    :ignored_notifications_mask, :frilans_finans_id, :frilans_finans_payment_details,
    :current_status, :at_und, :arrived_at, :country_of_origin, :managed, :verified,
    :account_clearing_number, :account_number, :gender, :full_street_address,
    :support_chat_activated, :linkedin_url, :bank_account, :facebook_url
  ] + EXTRA_ATTRIBUTES

  link(:self) { api_v1_user_url(object) }

  attribute :support_chat_activated { object.support_chat_activated? }
  attribute :description { object.original_description }
  attribute :description_html { to_html(object.original_description) }

  attribute :job_experience { object.original_job_experience }
  attribute :job_experience_html { to_html(object.original_job_experience) }

  attribute :education { object.original_education }
  attribute :education_html { to_html(object.original_education) }

  attribute :competence_text { object.original_competence_text }
  attribute :competence_text_html { to_html(object.original_competence_text) }

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

  has_one :company do
    link(:self) { api_v1_company_url(object.company) if object.company }
  end

  has_one :language do
    link(:self) { api_v1_language_url(object.language_id) if object.language_id }
  end

  has_one :system_language do
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

  has_many :user_documents, unless: :collection_serializer? do
    link(:related) { api_v1_user_documents_url(object.id) }

    object.user_documents
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
#  fk_rails_45f4f12508              (language_id => languages.id)
#  fk_rails_7682a3bdfe              (company_id => companies.id)
#  users_interviewed_by_user_id_fk  (interviewed_by_user_id => users.id)
#  users_system_language_id_fk      (system_language_id => languages.id)
#
