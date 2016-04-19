# frozen_string_literal: true
class UserImageSerializer < ActiveModel::Serializer
  ATTRIBUTES = [:one_time_token, :one_time_token_expires_at].freeze
  attributes ATTRIBUTES

  attribute :image_url
  attribute :image_url_large
  attribute :image_url_medium
  attribute :image_url_small

  has_one :user

  def image_url
    object.image.url
  end

  def image_url_large
    object.image.url(:large)
  end

  def image_url_medium
    object.image.url(:medium)
  end

  def image_url_small
    object.image.url(:small)
  end
end
