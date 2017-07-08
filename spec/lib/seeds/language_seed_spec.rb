# frozen_string_literal: true

require 'rails_helper'

require 'seeds/production/language_seed'

RSpec.describe LanguageSeed do
  it 'creates default rates' do
    expect do
      described_class.call
    end.to change(Language, :count).by(190)
  end
end
