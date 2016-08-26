# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserStatusesSerializer do
  describe '#serializeble_resource' do
    subject { described_class.serializeble_resource.to_h }

    it 'returns serialized statues' do
      data = subject[:data].first
      expect(data[:id]).to eq(1)
      expect(data[:attributes][:name]).to eq(I18n.t('user.statuses.asylum_seeker'))
    end
  end
end
