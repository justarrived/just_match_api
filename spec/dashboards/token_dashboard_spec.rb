# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TokenDashboard do
  subject { described_class.new }

  let(:token) { mock_model(Token, id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(token)).to eq('#1')
    end
  end
end
