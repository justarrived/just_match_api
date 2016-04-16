# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HourlyPayDashboard do
  subject { described_class.new }

  let(:company) { mock_model(HourlyPay, rate: 100, id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(company)).to eq('#1 100')
    end
  end
end
