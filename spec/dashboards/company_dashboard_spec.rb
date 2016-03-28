# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CompanyDashboard do
  subject { described_class.new }

  let(:company) { mock_model(Company, name: 'Company', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(company)).to eq('#1 Company')
    end
  end
end
