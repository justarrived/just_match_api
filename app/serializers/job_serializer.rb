# frozen_string_literal: true
class JobSerializer < ActiveModel::Serializer
  attributes :id, :description, :job_date, :created_at, :updated_at,
             :performed_accept, :performed, :longitude, :latitude, :name,
             :hours, :zip, :zip_latitude, :zip_longitude

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
#  id                        :integer          not null, primary key
#  max_rate                  :integer
#  description               :text
#  job_date                  :datetime
#  performed_accept          :boolean          default(FALSE)
#  performed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  owner_user_id             :integer
#  latitude                  :float
#  longitude                 :float
#  name                      :string
#  hours :float
#  language_id               :integer
#  street                    :string
#  zip                       :string
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57  (language_id => languages.id)
#
