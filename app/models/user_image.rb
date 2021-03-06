# frozen_string_literal: true

class UserImage < ApplicationRecord
  MAX_HOURS_AGE_AS_ORPHAN = 24
  ONE_TIME_TOKEN_VALID_FOR_HOURS = 10
  CATEGORIES = {
    profile: 1,
    personal_id: 2,
    work_permit_front: 3,
    work_permit_back: 4,
    lma_card: 5,
    residence_permit_front: 6,
    residence_permit_back: 7,
    skatteverket_certificate: 8,
    recruiter_profile: 9
  }.freeze

  belongs_to :user, optional: true

  before_create :generate_one_time_token

  IMAGE_STYLES = { large: '600x600>', medium: '300x300>', small: '100x100>' }.freeze
  IMAGE_DEFAULT_URL = '/images/:style/missing.png'
  IMAGE_MAX_MB_SIZE = 8

  has_attached_file :image, styles: IMAGE_STYLES, default_url: IMAGE_DEFAULT_URL, s3_protocol: :https # rubocop:disable Metrics/LineLength

  validates :category, presence: true
  validates :image, attachment_presence: true
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :image, less_than: IMAGE_MAX_MB_SIZE.megabytes

  scope :valid_one_time_tokens, (lambda {
    where('one_time_token_expires_at > ?', Time.zone.now)
  })
  scope :orhpans, (-> { where(user: nil) })
  scope :over_aged_orphans, (lambda {
    orhpans.where('created_at < ?', MAX_HOURS_AGE_AS_ORPHAN.hours.ago)
  })

  # NOTE: Figure out a good way to validate :current_status and :at_und
  #       see https://github.com/rails/rails/issues/13971
  enum category: CATEGORIES

  def self.replace_image(user:, image:, category:)
    new.tap do |user_image|
      user_image.user = user
      user_image.image = image
      user_image.category = category

      find_by(user: user, category: category)&.destroy! if user_image.valid?

      user_image.save
    end
  end

  def self.find_by_one_time_tokens(tokens)
    valid_one_time_tokens.where(one_time_token: tokens)
  end

  def self.find_by_one_time_token(token)
    valid_one_time_tokens.find_by(one_time_token: token)
  end

  def generate_one_time_token
    self.one_time_token_expires_at = Time.zone.now + ONE_TIME_TOKEN_VALID_FOR_HOURS.hours
    self.one_time_token = SecureGenerator.token
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
#  fk_rails_...  (user_id => users.id)
#
