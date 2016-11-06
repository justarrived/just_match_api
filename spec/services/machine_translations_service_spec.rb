# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MachineTranslationsService do
  let(:bad_locale_translation) { FactoryGirl.build(:job_translation, locale: 'wat') }
  let(:translation) { FactoryGirl.build(:job_translation, locale: 'ar') }
  let(:languages) { [FactoryGirl.build(:language)] }

  describe '#call' do
    let(:new_translation) { FactoryGirl.build(:job_translation) }

    it 'returns translations' do
      allow(MachineTranslationService).to receive(:call).and_return(new_translation)
      result = described_class.call(translation: translation, languages: languages)
      expect(result.length).to eq(1)
    end

    context 'ineligle locale' do
      it 'returns empty array' do
        expect(described_class.call(translation: bad_locale_translation)).to eq([])
      end
    end
  end
end
