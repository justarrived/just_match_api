# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TermsAgreementDashboard do
  subject { described_class.new }

  let(:job) { mock_model(TermsAgreement, version: 'v1', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(job)).to eq('#1 v1')
    end
  end
end
