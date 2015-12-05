class JobUserSerializer < ActiveModel::Serializer
  attributes :id, :accepted, :rate

  belongs_to :user
  belongs_to :job
end
