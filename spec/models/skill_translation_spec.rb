# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SkillTranslation, type: :model do
  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end
end

# == Schema Information
#
# Table name: skill_translations
#
#  id          :integer          not null, primary key
#  name        :string
#  locale      :string
#  language_id :integer
#  skill_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_skill_translations_on_language_id  (language_id)
#  index_skill_translations_on_skill_id     (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (skill_id => skills.id)
#
