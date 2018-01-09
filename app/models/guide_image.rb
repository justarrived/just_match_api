# frozen_string_literal: true

class GuideImage < ApplicationRecord
  IMAGE_STYLES = {
    xlarge: '900x900>',
    large: '600x600>',
    medium: '300x300>',
    small: '100x100>'
  }.freeze

  IMAGE_DEFAULT_URL = '/images/:style/missing.png'
  IMAGE_MAX_MB_SIZE = 8

  has_attached_file :image, styles: IMAGE_STYLES, default_url: IMAGE_DEFAULT_URL, s3_protocol: :https # rubocop:disable Metrics/LineLength

  validates :image, attachment_presence: true
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :image, less_than: IMAGE_MAX_MB_SIZE.megabytes

  def self.format_names
    IMAGE_STYLES.to_a.map { |style| style.join(': ') }
  end
end

# == Schema Information
#
# Table name: guide_images
#
#  id                 :integer          not null, primary key
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#
