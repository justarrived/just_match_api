# frozen_string_literal: true

class CompanyImageSerializer < ApplicationSerializer
  ATTRIBUTES = %i(one_time_token one_time_token_expires_at).freeze
  attributes ATTRIBUTES

  attribute :category_name
  attribute :image_url
  attribute :image_url_large
  attribute :image_url_medium
  attribute :image_url_small

  link(:self) { api_v1_company_image_url(object.company_id, object) if object.company_id }

  has_one :company

  def category_name
    'logo'
  end

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

# == Schema Information
#
# Table name: company_images
#
#  id                        :integer          not null, primary key
#  one_time_token_expires_at :datetime
#  one_time_token            :string
#  company_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  image_file_name           :string
#  image_content_type        :string
#  image_file_size           :integer
#  image_updated_at          :datetime
#
# Indexes
#
#  index_company_images_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
