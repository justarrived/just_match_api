# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserDashboard do
  subject { described_class.new }

  let(:user) { mock_model(User, name: 'User', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(user)).to eq('#1 User')
    end
  end
end
