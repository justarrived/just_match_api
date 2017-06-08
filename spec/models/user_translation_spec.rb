# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTranslation, type: :model do
  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end
end

# == Schema Information
#
# Table name: user_translations
#
#  id              :integer          not null, primary key
#  locale          :string
#  description     :text
#  job_experience  :text
#  education       :text
#  competence_text :text
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  language_id     :integer
#
# Indexes
#
#  index_user_translations_on_language_id  (language_id)
#  index_user_translations_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
