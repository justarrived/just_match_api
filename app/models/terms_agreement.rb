# frozen_string_literal: true
class TermsAgreement < ApplicationRecord
  belongs_to :frilans_finans_term

  validates :frilans_finans_term, presence: true
  validates :version, presence: true, uniqueness: true
  validates :url, presence: true

  validate :validate_url_with_protocol

  scope :regular_users, lambda {
    joins(:frilans_finans_term).where('frilans_finans_terms.company = ?',  false)
  }
  scope :company_users, lambda {
    joins(:frilans_finans_term).where('frilans_finans_terms.company = ?',  true)
  }

  def validate_url_with_protocol
    return if url.nil? || url_starts_with_protocol?(url)

    errors.add(:url, I18n.t('errors.general.protocol_missing'))
  end

  def self.current_user_terms
    regular_users.last
  end

  def self.current_company_user_terms
    company_users.last
  end

  def company_terms?
    frilans_finans_term.company
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
#  id                     :integer          not null, primary key
#  version                :string
#  url                    :string(2000)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  frilans_finans_term_id :integer
#
# Indexes
#
#  index_terms_agreements_on_frilans_finans_term_id  (frilans_finans_term_id)
#  index_terms_agreements_on_version                 (version) UNIQUE
#
# Foreign Keys
#
#  fk_rails_d0dcb0c0f5  (frilans_finans_term_id => frilans_finans_terms.id)
#
