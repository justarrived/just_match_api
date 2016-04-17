# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansImporter do
  subject { described_class }

  describe '#professions' do
    let(:professions_mock) do
      resource = OpenStruct.new(attributes: { 'title' => 'watman' }, id: 1)
      Struct.new(:resources).new([resource])
    end

    it 'can import professions' do
      allow(FrilansFinansApi::Profession).to receive(:walk).and_yield(professions_mock)

      expect do
        described_class.professions
      end.to change(Category, :count).by(1)
    end
  end

  describe '#currencies' do
    let(:currencies_mock) do
      resource = OpenStruct.new(attributes: { 'currency_code' => 'SEK' }, id: 1)
      Struct.new(:resources).new([resource])
    end

    it 'can import currencies' do
      allow(FrilansFinansApi::Currency).to receive(:walk).and_yield(currencies_mock)

      expect do
        described_class.currencies
      end.to change(Currency, :count).by(1)
    end
  end
end
