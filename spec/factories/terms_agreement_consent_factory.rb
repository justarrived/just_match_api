# frozen_string_literal: true

FactoryGirl.define do
  factory :terms_agreement_consent do
    association :user
    association :job
    association :terms_agreement

    factory :terms_agreement_consent_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
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
#  fk_rails_388a50da05  (user_id => users.id)
#  fk_rails_94839d2aec  (job_id => jobs.id)
#  fk_rails_d2e6843d3e  (terms_agreement_id => terms_agreements.id)
#
