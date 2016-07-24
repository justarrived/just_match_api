# frozen_string_literal: true
class CompanyImage < ActiveRecord::Base
  MAX_HOURS_AGE_AS_ORPHAN = 24
  ONE_TIME_TOKEN_VALID_FOR_HOURS = 10

  belongs_to :company, optional: true

  before_create :generate_one_time_token

  scope :valid_one_time_tokens, lambda {
    where('one_time_token_expires_at > ?', Time.zone.now)
  }

  IMAGE_STYLES = { large: '600x600>', medium: '300x300>', small: '100x100>' }.freeze
  IMAGE_DEFAULT_URL = '/images/:style/missing.png'
  IMAGE_MAX_MB_SIZE = 8

  has_attached_file :image, styles: IMAGE_STYLES, default_url: IMAGE_DEFAULT_URL

  validates :image, attachment_presence: true
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :image, less_than: IMAGE_MAX_MB_SIZE.megabytes

  scope :orhpans, -> () { where(company: nil) }
  scope :over_aged_orphans, lambda {
    orhpans.where('created_at < ?', MAX_HOURS_AGE_AS_ORPHAN.hours.ago)
  }

  def self.find_by_one_time_token(token)
    valid_one_time_tokens.find_by(one_time_token: token)
  end

  def category_name
    'logo'
  end

  def generate_one_time_token
    self.one_time_token_expires_at = Time.zone.now + ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
    self.one_time_token = SecureGenerator.token
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
#  fk_rails_6dcf524eba  (company_id => companies.id)
#
