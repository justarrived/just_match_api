class UserLanguageSerializer < ActiveModel::Serializer
  attributes :id
  has_one :language
  has_one :user
end
