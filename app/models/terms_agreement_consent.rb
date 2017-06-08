# frozen_string_literal: true

class TermsAgreementConsent < ApplicationRecord
  belongs_to :user
  belongs_to :job
  belongs_to :terms_agreement

  validates :terms_agreement, presence: true
  validates :user, presence: true, uniqueness: { scope: :job }
  validates :job, uniqueness: { scope: :user }
  validates :job, presence: true, unless: :company_terms?

  delegate :company_terms?, to: :terms_agreement, allow_nil: true
end

# == Schema Information
#
# Table name: terms_agreement_consents
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  job_id             :integer
#  terms_agreement_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_terms_agreement_consents_on_job_id              (job_id)
#  index_terms_agreement_consents_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_terms_agreement_consents_on_terms_agreement_id  (terms_agreement_id)
#  index_terms_agreement_consents_on_user_id             (user_id)
#  index_terms_agreement_consents_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (terms_agreement_id => terms_agreements.id)
#  fk_rails_...  (user_id => users.id)
#
