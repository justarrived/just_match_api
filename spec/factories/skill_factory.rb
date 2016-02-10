# frozen_string_literal: true
FactoryGirl.define do
  factory :skill do
    sequence :name do |n|
      "Skill #{n} #{SecureRandom.uuid}"
    end
    association :language
  end
end

# == Schema Information
#
# Table name: skills
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_07eab65450  (language_id => languages.id)
#
