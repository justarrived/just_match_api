# frozen_string_literal: true
class Document < ApplicationRecord
  CONTENT_TYPES = DocumentContentTypeHelper::CONTENT_TYPES_MAP.keys.freeze
  DOCUMENT_MAX_MB_SIZE = 8

  ONE_TIME_TOKEN_VALID_FOR_HOURS = 10

  has_many :user_documents
  has_many :users, through: :user_documents

  before_create :generate_one_time_token

  scope :valid_one_time_tokens, lambda {
    where('one_time_token_expires_at > ?', Time.zone.now)
  }

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

  delegate :url, to: :document

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
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#
