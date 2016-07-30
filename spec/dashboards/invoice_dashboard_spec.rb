# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvoiceDashboard do
  subject { described_class.new }

  let(:invoice) { mock_model(Invoice, name: 'Invoice', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(invoice)).to eq('#1 Invoice')
    end
  end
end
