# frozen_string_literal: true

require 'rails_helper'

require 'seeds/production/currency_seed'

RSpec.describe CurrencySeed do
  it 'creates default rates' do
    allow(FrilansFinansImporter).to receive(:currencies).and_return(nil)
    described_class.call
    expect(FrilansFinansImporter).to have_received(:currencies).once
  end
end
