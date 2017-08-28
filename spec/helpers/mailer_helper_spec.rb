# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailerHelper, type: :helper do
  describe '#join_in_locale_order' do
    it 'returns empty string if passed empty array' do
      expect(helper.join_in_locale_order([])).to eq('')
    end

    [
      [:sv, %w[a b c], 'a b c'],
      [:en, %w[a b c], 'a b c'],
      [:ar, %w[a b c], 'c b a']
    ].each do |data|
      locale, input, expected = data

      it 'returns correct string' do
        expect(helper.join_in_locale_order(input, locale: locale)).to eq(expected)
      end
    end
  end
end
