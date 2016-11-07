# frozen_string_literal: true
class UserSerializer < ApplicationSerializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all User column names here
  EXTRA_ATTRIBUTES = %i(ignored_notifications auth_token primary_role).freeze
  attributes [
    :id, :email, :phone, :description, :created_at, :updated_at, :latitude, :longitude,
    :language_id, :anonymized, :password_hash, :password_salt, :admin, :street, :zip,
    :zip_latitude, :zip_longitude, :first_name, :last_name, :ssn, :company_id, :banned,
    :one_time_token, :one_time_token_expires_at,
    :ignored_notifications_mask, :frilans_finans_id, :frilans_finans_payment_details,
    :current_status, :at_und, :arrived_at, :country_of_origin, :managed
  ] + EXTRA_ATTRIBUTES

  link(:self) { api_v1_user_url(object) }

  attribute :description do
    object.translated_description
  end

  attribute :job_experience do
    object.translated_job_experience
  end

  attribute :education do
    object.translated_education
  end

  attribute :competence_text do
    object.translated_competence_text
  end

  attribute :original_text do
    {
      description: object.original_description,
      job_experience: object.original_job_experience,
      education: object.original_education,
      competence_text: object.original_competence_text
    }
  end

  has_one :company do
    link(:self) { api_v1_company_url(object.company) if object.company }
  end

  has_one :language do
    link(:self) { api_v1_language_url(object.language_id) if object.language_id }
  end

  has_many :user_images

  has_many :languages do
    link(:related) { api_v1_user_languages_url(object.id) }
  end

  has_many :user_languages do
    link(:related) { api_v1_user_languages_url(object.id) }
  end

  has_many :chats, unless: :collection_serializer? do
    link(:related) { api_v1_user_chats_url(object.id) }
  end

  def attributes(_)
    data = super

    data.slice(*policy.present_attributes(collection: collection_serializer?))
  end

  private

  def policy
    @_user_policy ||= UserPolicy.new(scope[:current_user], object)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  email                          :string
#  phone                          :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  latitude                       :float
#  longitude                      :float
#  language_id                    :integer
#  anonymized                     :boolean          default(FALSE)
#  password_hash                  :string
#  password_salt                  :string
#  admin                          :boolean          default(FALSE)
#  street                         :string
#  zip                            :string
#  zip_latitude                   :float
#  zip_longitude                  :float
#  first_name                     :string
#  last_name                      :string
#  ssn                            :string
#  company_id                     :integer
#  banned                         :boolean          default(FALSE)
#  one_time_token                 :string
#  one_time_token_expires_at      :datetime
#  ignored_notifications_mask     :integer
#  frilans_finans_id              :integer
#  frilans_finans_payment_details :boolean          default(FALSE)
#  current_status                 :integer
#  at_und                         :integer
#  arrived_at                     :date
#  country_of_origin              :string
#  managed                        :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_company_id         (company_id)
#  index_users_on_email              (email) UNIQUE
#  index_users_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_users_on_language_id        (language_id)
#  index_users_on_one_time_token     (one_time_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
