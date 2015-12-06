class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :description, :created_at, :longitude,
    :latitude, :address

  has_many :languages
end
