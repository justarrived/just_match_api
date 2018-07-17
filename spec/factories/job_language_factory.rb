# frozen_string_literal: true

FactoryBot.define do
  factory :job_language do
    association :job
    association :language
    proficiency 1
    proficiency_by_admin 1
  end
end

# == Schema Information
#
# Table name: job_languages
#
#  id                   :integer          not null, primary key
#  job_id               :integer
#  language_id          :integer
#  proficiency          :integer
#  proficiency_by_admin :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_job_languages_on_job_id       (job_id)
#  index_job_languages_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (language_id => languages.id)
#
