# frozen_string_literal: true
FactoryGirl.define do
  factory :interest do
    name 'Some interest'
    internal false
    association :language

    factory :interest_with_translation do
      after(:create) do |interest, _evaluator|
        interest.set_translation(name: interest.name)
      end
    end

    factory :interest_for_docs do
      id 1
      name 'Event'
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  name        :string
#  language_id :integer
#  internal    :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_4b04e42f8f  (language_id => languages.id)
#
