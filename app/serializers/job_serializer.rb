# frozen_string_literal: true
class JobSerializer < ApplicationSerializer
  attributes [
    :id, :job_date, :hours, :created_at, :updated_at, :owner_user_id,
    :latitude, :longitude, :language_id, :street, :zip, :zip_latitude, :zip_longitude,
    :hidden, :category_id, :hourly_pay_id, :verified, :job_end_date, :cancelled, :filled,
    :featured, :upcoming, :amount, :invoice_amount, :language_id
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

  attribute :translated_text do
    {
      name: object.translated_name,
      short_description: object.translated_short_description,
      description: object.translated_description,
      language_id: object.translated_language_id
    }
  end

  has_many :job_users do
    # Only disclose job users to the job owner
    user = scope[:current_user]
    if user && (user.id == object.owner_user_id || user.admin)
      object.job_users
    else
      []
    end
  end

  has_many :comments, unless: :collection_serializer? do
    link(:related) { api_v1_job_comments_url(job_id: object.id) }

    object.comments.visible
  end

  has_one :owner do
    link(:self) do
      api_v1_user_url(object.owner_user_id) if object.owner_user_id && !object.upcoming
    end

    if object.upcoming
      User.build_anonymous(role: :owner)
    else
      object.owner
    end
  end

  has_one :company do
    # Anonymize the company if the job is upcoming
    link(:self) do
      api_v1_company_url(object.company) if object.company && !object.upcoming
    end

    if object.upcoming
      Company.build_anonymous
    else
      object.company
    end
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
    @_job_policy ||= JobPolicy.new(scope[:current_user], object)
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                :integer          not null, primary key
#  description       :text
#  job_date          :datetime
#  hours             :float
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  owner_user_id     :integer
#  latitude          :float
#  longitude         :float
#  language_id       :integer
#  street            :string
#  zip               :string
#  zip_latitude      :float
#  zip_longitude     :float
#  hidden            :boolean          default(FALSE)
#  category_id       :integer
#  hourly_pay_id     :integer
#  verified          :boolean          default(FALSE)
#  job_end_date      :datetime
#  cancelled         :boolean          default(FALSE)
#  filled            :boolean          default(FALSE)
#  short_description :string
#  featured          :boolean          default(FALSE)
#  upcoming          :boolean          default(FALSE)
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
