class JobSerializer < ActiveModel::Serializer
  attributes :id, :max_rate, :description, :job_date, :created_at, :updated_at,
    :performed_accept, :performed, :longitude, :latitude, :name, :address, :estimated_completion_time

  has_many :users, key: :applicants
  has_many :comments

  has_one :owner
  has_one :language
end
