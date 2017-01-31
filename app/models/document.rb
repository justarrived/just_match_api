# frozen_string_literal: true
class Document < ApplicationRecord
  CONTENT_TYPES = %w(
    application/pdf
    application/msword
    application/zip
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
  ).freeze
  DOCUMENT_MAX_MB_SIZE = 8

  ONE_TIME_TOKEN_VALID_FOR_HOURS = 10
  CATEGORIES = { cv: 1 }.freeze

  before_create :generate_one_time_token

  scope :valid_one_time_tokens, lambda {
    where('one_time_token_expires_at > ?', Time.zone.now)
  }

  # NOTE: Figure out a good way to validate #category
  #       see https://github.com/rails/rails/issues/13971
  enum category: CATEGORIES

  validates :category, presence: true

  has_attached_file :document, s3_protocol: :https

  validates :document, attachment_presence: true
  validates_attachment_content_type :document, content_type: CONTENT_TYPES
  validates_attachment_size :document, less_than: DOCUMENT_MAX_MB_SIZE.megabytes

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
# Table name: documents
#
#  id                        :integer          not null, primary key
#  category                  :integer
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#
