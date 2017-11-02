# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Skill, type: :model do
  describe '#display_name' do
    it 'returns the correct display name' do
      id = 7
      skill = FactoryBot.build(:skill, id: id)
      expect(skill.display_name).to eq("##{id} #{skill.name}")
    end
  end

  describe '#to_form_array' do
    context 'with include blank false' do
      it 'returns empty array if no skills' do
        skill_array = described_class.to_form_array(include_blank: false)
        expect(skill_array).to eq([])
      end

      it 'returns skill array' do
        skill = FactoryBot.create(:skill_with_translation)
        skill_array = described_class.to_form_array(include_blank: false)
        expect(skill_array).to eq([[skill.name, skill.id]])
      end
    end

    context 'with include blank' do
      let(:label) { I18n.t('admin.form.no_skill_chosen') }

      it 'returns empty array if no skills' do
        skill_array = described_class.to_form_array(include_blank: true)
        expect(skill_array).to eq([[label, nil]])
      end

      it 'returns skill array' do
        skill = FactoryBot.create(:skill_with_translation)
        skill_array = described_class.to_form_array(include_blank: true)
        expect(skill_array).to eq([[label, nil], [skill.name, skill.id]])
      end
    end
  end
end

# == Schema Information
#
# Table name: skills
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :integer
#  internal      :boolean          default(FALSE)
#  color         :string
#  high_priority :boolean          default(FALSE)
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
