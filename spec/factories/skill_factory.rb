# frozen_string_literal: true
FactoryGirl.define do
  factory :skill do
    sequence :name do |n|
      "Skill #{n} #{SecureGenerator.token(length: 32)}"
    end
    association :language

    factory :skill_with_translation do
      after(:create) do |skill, _evaluator|
        skill.set_translation(name: skill.name)
      end
    end

    factory :skill_for_docs do
      id 1
      name 'Carpenter'
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: skills
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :integer
#  internal      :boolean          default(FALSE)
#  color         :string
#  high_priority :boolean          default(FALSE)
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_07eab65450  (language_id => languages.id)
#
