# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaqTranslation, type: :model do
  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end
end

# == Schema Information
#
# Table name: faq_translations
#
#  id          :integer          not null, primary key
#  locale      :string
#  question    :text
#  answer      :text
#  language_id :integer
#  faq_id      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_faq_translations_on_faq_id       (faq_id)
#  index_faq_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (faq_id => faqs.id)
#  fk_rails_...  (language_id => languages.id)
#
