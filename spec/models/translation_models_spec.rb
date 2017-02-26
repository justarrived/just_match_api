# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Translation models' do
  it 'all translation models include the TranslationModel module' do
    ApplicationRecord.descendants.each do |model|
      next unless model.table_name.ends_with?('_translations')

      expect(model.ancestors.include?(TranslationModel)).to eq(true)
    end
  end
end
