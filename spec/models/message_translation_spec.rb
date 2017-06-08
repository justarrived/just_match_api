# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageTranslation, type: :model do
  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end
end

# == Schema Information
#
# Table name: message_translations
#
#  id          :integer          not null, primary key
#  locale      :string
#  body        :text
#  message_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#
# Indexes
#
#  index_message_translations_on_language_id  (language_id)
#  index_message_translations_on_message_id   (message_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (message_id => messages.id)
#
