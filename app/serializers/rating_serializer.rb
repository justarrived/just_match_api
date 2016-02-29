# frozen_string_literal: true
class RatingSerializer < ActiveModel::Serializer
  attributes :id, :score

  has_one :job
  has_one :from_user
  has_one :to_user
  has_one :comment
end
