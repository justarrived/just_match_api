# frozen_string_literal: true

FactoryGirl.define do
  factory :faq do
    answer 'An answer'
    question 'A question'
    association :language

    factory :faq_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  answer      :text
#  question    :text
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_faqs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
