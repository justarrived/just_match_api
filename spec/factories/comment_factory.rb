# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    body 'Something, something darkside..'
    association :language
    association :owner, factory: :user
    association :commentable, factory: :job

    factory :comment_for_docs do
      id 1
      body 'Typewriter hashtag ennui brunch post-ironic food truck vinegar.'
      commentable_type 'Job'
      commentable_id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1)
      updated_at Time.new(2016, 02, 12, 1, 1, 1)
    end
  end
end
# rubocop:disable Metrics/LineLength

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  commentable_id   :integer
#  commentable_type :string
#  owner_user_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  language_id      :integer
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_language_id                          (language_id)
#
# Foreign Keys
#
#  fk_rails_f55d9b0548  (language_id => languages.id)
#
