# frozen_string_literal: true

FactoryGirl.define do
  factory :comment_translation do
    locale 'en'
    body 'Something something, darkside'
    association :comment
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
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (language_id => languages.id)
#
