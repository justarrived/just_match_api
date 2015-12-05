class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :description, :created_at, :longitude,
    :latitude
end
