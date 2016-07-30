# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HourlyPayDashboard do
  subject { described_class.new }

  let(:pay) { mock_model(HourlyPay, gross_salary: 100, id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(pay)).to eq('#1 100')
    end
  end
end
