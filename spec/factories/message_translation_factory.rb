# frozen_string_literal: true

FactoryBot.define do
  factory :message_translation do
    locale 'MyString'
    body 'MyText'
    association :message
    association :language
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
