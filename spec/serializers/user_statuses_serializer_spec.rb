# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserStatusesSerializer do
  describe '#serializable_resource' do
    subject { described_class.serializable_resource.to_h }

    it 'returns serialized statues' do
      I18n.with_locale(:ar) do
        data = subject[:data].first
        expect(data[:id]).to eq(:asylum_seeker)

        ar_name = I18n.t('user.statuses.asylum_seeker', locale: :ar)

        expect(data[:attributes][:name]).to eq(ar_name)
        expect(data[:attributes][:translated_text][:name]).to eq(ar_name)
      end
    end
  end
end
