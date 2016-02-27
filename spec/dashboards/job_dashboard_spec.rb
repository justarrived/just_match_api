# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobDashboard do
  subject { described_class.new }

  let(:job) { mock_model(Job, name: 'Job', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(job)).to eq('#1 Job')
    end
  end
end
