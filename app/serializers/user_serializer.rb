class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :description, :created_at, :longitude,
    :latitude, :address

  has_one :language

  has_many :languages
  has_many :written_comments
  has_many :comments
  has_many :skills
  has_many :jobs
end
