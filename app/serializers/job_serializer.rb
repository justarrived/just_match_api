# frozen_string_literal: true
class JobSerializer < ActiveModel::Serializer
  # Since the #attributes method is overriden and provides a whitelist of attribute_names
  # that can be returned to the user we can return all Job column names here
  attributes Job.column_names.map(&:to_sym)

  has_many :comments do
    object.comments.visible
  end

  has_one :owner
  has_one :company
  has_one :language
  has_one :category
  has_one :hourly_pay

  def attributes(_)
    data = super

    data.slice(*policy.present_attributes)
  end

  private

  def policy
    @_job_policy ||= JobPolicy.new(scope[:current_user], object)
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  description   :text
#  job_date      :datetime
#  hours         :float
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_user_id :integer
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  hidden        :boolean          default(FALSE)
#  category_id   :integer
#  hourly_pay_id :integer
#  verified      :boolean          default(FALSE)
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406    (category_id => categories.id)
#  fk_rails_70cb33aa57    (language_id => languages.id)
#  fk_rails_b144fc917d    (hourly_pay_id => hourly_pays.id)
#  jobs_owner_user_id_fk  (owner_user_id => users.id)
#
