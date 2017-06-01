# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobTranslation, type: :model do
  subject do
    FactoryGirl.build(
      :job_translation,
      name: 'Wat',
      short_description: 'Short',
      description: 'Desc'
    )
  end

  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end

  describe '#changed_translation_fields' do
    subject { FactoryGirl.create(:job_translation) }

    it 'returns a list of changed translation attributes' do
      subject.name = 'Watwoman'
      expect(subject.changed_translation_fields).to eq(%w(name))
    end
  end

  describe '#unchanged_translation_fields' do
    subject { FactoryGirl.create(:job_translation) }

    it 'returns a list of changed translation attributes' do
      subject.name = 'Watwoman'
      expected = %w(short_description description)
      expect(subject.unchanged_translation_fields).to eq(expected)
    end
  end

  describe '#translates_model' do
    it 'returns job model' do
      expect(subject.translates_model).to be_a(Job)
    end
  end

  describe '#build_model_attributes' do
    it 'returns model attributes' do
      result = subject.translation_attributes
      expected = {
        'name' => 'Wat',
        'short_description' => 'Short',
        'description' => 'Desc'
      }
      expect(result).to eq(expected)
    end
  end
end

# == Schema Information
#
# Table name: job_translations
#
#  id                :integer          not null, primary key
#  locale            :string
#  short_description :string
#  name              :string
#  description       :text
#  job_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language_id       :integer
#
# Indexes
#
#  index_job_translations_on_job_id       (job_id)
#  index_job_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_a8f6a40518  (language_id => languages.id)
#  fk_rails_f6d3a9562e  (job_id => jobs.id)
#
