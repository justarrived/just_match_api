# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentTranslation, type: :model do
  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end
end

# == Schema Information
#
# Table name: comment_translations
#
#  id          :integer          not null, primary key
#  locale      :string
#  body        :text
#  comment_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#
# Indexes
#
#  index_comment_translations_on_comment_id   (comment_id)
#  index_comment_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_1220847173  (language_id => languages.id)
#  fk_rails_7d8cab2ad8  (comment_id => comments.id)
#
