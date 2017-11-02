# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobRequest, type: :model do
  describe '#validate_company_relation_or_company_details' do
    it 'does not add error if company relation exists' do
      company = FactoryBot.build_stubbed(:company)
      request = JobRequest.new(company: company)
      request.validate_company_relation_or_company_details

      expect(request.errors[:company]).to be_empty
    end

    it 'does not add error if company details exist' do
      request = JobRequest.new(
        company_name: 'ACME AB',
        company_org_no: '5555555555',
        company_email: 'company_email',
        company_address: 'company_address'
      )
      request.validate_company_relation_or_company_details

      expect(request.errors).to be_empty
    end

    it 'adds error(s) if neither company relation or company details exist' do
      request = JobRequest.new
      request.validate_company_relation_or_company_details

      expect(request.errors[:company]).not_to be_empty
      expect(request.errors[:company_org_no]).not_to be_empty
      expect(request.errors[:company_email]).not_to be_empty
      expect(request.errors[:company_address]).not_to be_empty
    end
  end
end

# == Schema Information
#
# Table name: job_requests
#
#  id                    :integer          not null, primary key
#  company_name          :string
#  contact_string        :string
#  assignment            :string
#  job_scope             :string
#  job_specification     :string
#  language_requirements :string
#  job_at_date           :string
#  responsible           :string
#  suitable_candidates   :string
#  comment               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  short_name            :string
#  finished              :boolean          default(FALSE)
#  cancelled             :boolean          default(FALSE)
#  draft_sent            :boolean          default(FALSE)
#  signed_by_customer    :boolean          default(FALSE)
#  requirements          :string
#  hourly_pay            :string
#  company_org_no        :string
#  company_email         :string
#  company_phone         :string
#  company_address       :string
#  company_id            :integer
#  delivery_user_id      :integer
#  sales_user_id         :integer
#
# Indexes
#
#  index_job_requests_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...                      (company_id => companies.id)
#  job_requests_delivery_user_id_fk  (delivery_user_id => users.id)
#  job_requests_sales_user_id_fk     (sales_user_id => users.id)
#
