# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ContactDashboard do
  subject { described_class.new }

  let(:contact) { mock_model(Contact, name: 'Contact', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(contact)).to eq('#1 Contact')
    end
  end
end
