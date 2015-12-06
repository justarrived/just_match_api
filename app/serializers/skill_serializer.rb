class SkillSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :language
end
