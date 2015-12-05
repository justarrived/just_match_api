class JobSerializer < ActiveModel::Serializer
  attributes :id, :max_rate, :description, :job_date, :created_at, :updated_at,
    :performed, :longitude, :latitude, :name, :address

  has_many :users, key: :applicants
  has_one :owner
end
