# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvoiceSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:invoice) }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %w(job-user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('invoices')
    end
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                :integer          not null, primary key
#  frilans_finans_id :integer
#  job_user_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_invoices_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_invoices_on_job_user_id        (job_user_id)
#  index_invoices_on_job_user_id_uniq   (job_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_c894e05ce5  (job_user_id => job_users.id)
#
