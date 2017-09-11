# frozen_string_literal: true

require 'rails_helper'

require 'seeds/production/category_seed'

RSpec.describe CategorySeed do
  it 'creates default categories' do
    allow(FrilansFinansImporter).to receive(:professions).and_return(nil)
    described_class.call
    expect(FrilansFinansImporter).to have_received(:professions).once
  end
end
