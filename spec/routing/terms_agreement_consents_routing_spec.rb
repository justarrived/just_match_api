# frozen_string_literal: true

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

require 'rails_helper'

RSpec.describe Api::V1::TermsAgreementConsentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/terms-consents'
      route_path = 'api/v1/terms_agreement_consents#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
