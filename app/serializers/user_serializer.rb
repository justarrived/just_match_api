# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all User column names here
  attributes User.column_names.map(&:to_sym)

  has_one :language

  has_many :languages
  has_many :written_comments
  has_many :skills
  has_many :jobs

  def attributes(_)
    data = super
    # Doxxer invokes the serializer on non-persisted objects,
    # so we need to check if the record is persisted
    if object.persisted?
      data.slice(*policy.present_attributes)
    else
      data
    end
  end

  private

  def policy
    @_user_policy ||= UserPolicy.new(current_user, object)
  end
end

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  first_name    :string
#  last_name     :string
#
# Indexes
#
#  index_users_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#
