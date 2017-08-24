# frozen_string_literal: true

FactoryGirl.define do
  factory :occupation do
    name 'MyString'
    association :language

    factory :occupation_with_translation do
      after(:create) do |occupation, _evaluator|
        occupation.set_translation(name: occupation.name)
      end
    end

    factory :occupation_for_docs do
      id 1
      name 'Carpenter'
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  name        :string
#  ancestry    :string
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_occupations_on_ancestry     (ancestry)
#  index_occupations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
