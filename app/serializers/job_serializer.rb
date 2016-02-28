# frozen_string_literal: true
class JobSerializer < ActiveModel::Serializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all Job column names here
  attributes Job.column_names.map(&:to_sym)

  has_many :users, key: :applicants do
    # Doxxer invokes the serializer on non-persisted objects,
    # so we need to check if the record is persisted
    if object.persisted?
      applicant_records
    else
      User.none
    end
  end
  has_many :comments

  has_one :owner
  has_one :language

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

  def applicant_records
    if policy.present_applicants?
      object.users
    elsif policy.present_self_applicant?
      [current_user]
    else
      User.none
    end
  end

  def policy
    @_job_policy ||= JobPolicy.new(current_user, object)
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  max_rate         :integer
#  description      :text
#  job_date         :datetime
#  performed_accept :boolean          default(FALSE)
#  performed        :boolean          default(FALSE)
#  hours            :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_user_id    :integer
#  latitude         :float
#  longitude        :float
#  name             :string
#  language_id      :integer
#  street           :string
#  zip              :string
#  zip_latitude     :float
#  zip_longitude    :float
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57    (language_id => languages.id)
#  jobs_owner_user_id_fk  (owner_user_id => users.id)
#
