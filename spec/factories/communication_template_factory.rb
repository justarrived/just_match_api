# frozen_string_literal: true

FactoryBot.define do
  factory :communication_template do
    association :language
    category 'new_job_template'
    subject 'Communication subject'
    body 'Something, something darkside..'
  end
end

# == Schema Information
#
# Table name: communication_templates
#
#  id          :integer          not null, primary key
#  language_id :integer
#  category    :string
#  subject     :string
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_communication_templates_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
