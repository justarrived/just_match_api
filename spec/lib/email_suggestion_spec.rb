# frozen_string_literal: true

require 'rails_helper'
require 'email_suggestion'

RSpec.describe EmailSuggestion do
  describe '::call' do
    [
      ['example@gamil.com', 'gmail.com'],
      ['example@gmial.com', 'gmail.com'],
      ['example@GMAIL.com', nil],
      ['example@gotmail.com', 'hotmail.com'],
      ['example@htmail.com', 'hotmail.com'],
      ['example@hotnail.com', 'hotmail.com'],
      ['example@hotlail.com', 'hotmail.com'],
      ['example@outlook.sa', 'outlook.com'],
      ['example@icloud.se', 'icloud.com'],
      ['example@telia.se', nil],
      ['example@binero.se', nil],
      ['example@one.se', nil],
      ['example@one.nu', nil],
      ['hej@justarrived.se', nil]
    ].each do |parts|
      input, expected_domain = parts

      it "returns correct suggestion, if any, for #{input}" do
        expect(described_class.call(input)[:domain]).to eq(expected_domain)
      end
    end
  end
end
