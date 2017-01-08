# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SkillTranslation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
#  fk_rails_c9679897a6  (language_id => languages.id)
#  fk_rails_cf44d9c794  (skill_id => skills.id)
#
