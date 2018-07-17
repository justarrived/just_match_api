# frozen_string_literal: true

require 'rails_helper'

require 'seeds/production/occupation_seed'

RSpec.describe OccupationSeed do
  it 'creates default occupations' do
    FactoryBot.create(:language, lang_code: :en)
    FactoryBot.create(:language, lang_code: :sv)
    FactoryBot.create(:language, lang_code: :ar)
    expect do
      expect do
        described_class.call
      end.to change(OccupationTranslation, :count).by(387)
    end.to change(Occupation, :count).by(129)

    root_occupation = Occupation.roots.last
    expect(root_occupation.parent).to be_nil
    expect(root_occupation.name).to eq('Utbildning')
    expect(root_occupation.translated_name(locale: :ar)).to eq('التعليم')
    expect(root_occupation.translated_name(locale: :en)).to eq('Education')

    last_occupation = Occupation.children_of(root_occupation).last
    expect(last_occupation.name).to eq('Barnskötare')
    expect(last_occupation.translated_name(locale: :ar)).to eq('تعليم خاص')
    expect(last_occupation.translated_name(locale: :en)).to eq('Children caretaker')
  end
end
