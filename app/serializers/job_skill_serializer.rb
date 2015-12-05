class JobSkillSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :job
  belongs_to :skill
end
