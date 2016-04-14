# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all User column names here
  attributes User.column_names.map(&:to_sym) + %i(ignored_notifications)

  has_one :company
  has_one :language

  has_many :languages
  has_many :chats

  def attributes(_)
    data = super

    data.slice(*policy.present_attributes)
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
#  id                         :integer          not null, primary key
#  email                      :string
#  phone                      :string
#  description                :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  latitude                   :float
#  longitude                  :float
#  language_id                :integer
#  anonymized                 :boolean          default(FALSE)
#  auth_token                 :string
#  password_hash              :string
#  password_salt              :string
#  admin                      :boolean          default(FALSE)
#  street                     :string
#  zip                        :string
#  zip_latitude               :float
#  zip_longitude              :float
#  first_name                 :string
#  last_name                  :string
#  ssn                        :string
#  company_id                 :integer
#  banned                     :boolean          default(FALSE)
#  job_experience             :text
#  education                  :text
#  one_time_token             :string
#  one_time_token_expires_at  :datetime
#  ignored_notifications_mask :integer
#  frilans_finans_id          :integer
#
# Indexes
#
#  index_users_on_auth_token         (auth_token) UNIQUE
#  index_users_on_company_id         (company_id)
#  index_users_on_email              (email) UNIQUE
#  index_users_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_users_on_language_id        (language_id)
#  index_users_on_one_time_token     (one_time_token) UNIQUE
#  index_users_on_ssn                (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
