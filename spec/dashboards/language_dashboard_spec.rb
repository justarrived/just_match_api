# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LanguageDashboard do
  subject { described_class.new }

  let(:job) { mock_model(Language, lang_code: 'en', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(job)).to eq('#1 en')
    end
  end
end
