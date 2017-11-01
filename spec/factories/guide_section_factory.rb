# frozen_string_literal: true

FactoryBot.define do
  factory :guide_section do
    order 1
    association :language
  end
end

# == Schema Information
#
# Table name: guide_sections
#
#  id          :integer          not null, primary key
#  order       :integer
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_guide_sections_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
