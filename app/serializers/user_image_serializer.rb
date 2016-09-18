# frozen_string_literal: true
class UserImageSerializer < ApplicationSerializer
  ATTRIBUTES = [:one_time_token, :one_time_token_expires_at, :category].freeze
  attributes ATTRIBUTES

  attribute :category_name
  attribute :image_url
  attribute :image_url_large
  attribute :image_url_medium
  attribute :image_url_small

  link(:self) { api_v1_user_image_url(object.user_id, object) }

  has_one :user

  def image_url
    object.image.url
  end

  def category_name
    object.category
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

# == Schema Information
#
# Table name: user_images
#
#  id                        :integer          not null, primary key
#  one_time_token_expires_at :datetime
#  one_time_token            :string
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  image_file_name           :string
#  image_content_type        :string
#  image_file_size           :integer
#  image_updated_at          :datetime
#  category                  :integer
#
# Indexes
#
#  index_user_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_435d77ec18  (user_id => users.id)
#
