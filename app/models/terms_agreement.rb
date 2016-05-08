# frozen_string_literal: true
class TermsAgreement < ActiveRecord::Base
  validates :version, presence: true, uniqueness: true
  validates :url, presence: true

  validate :validate_url_with_protocol

  def validate_url_with_protocol
    return if url.nil? || url_starts_with_protocol?(url)

    errors.add(:url, I18n.t('errors.general.protocol_missing'))
  end

  private

  def url_starts_with_protocol?(url)
    url.starts_with?('http://') || url.starts_with?('https://')
  end
end

# == Schema Information
#
# Table name: terms_agreements
#
#  id         :integer          not null, primary key
#  version    :string
#  url        :string(2000)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_terms_agreements_on_version  (version) UNIQUE
#
