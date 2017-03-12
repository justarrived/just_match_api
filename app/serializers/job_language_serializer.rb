# frozen_string_literal: true
class JobLanguageSerializer < ApplicationSerializer
  has_one :job
  has_one :language
end

# == Schema Information
#
# Table name: job_languages
#
#  id                   :integer          not null, primary key
#  job_id               :integer
#  language_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_job_languages_on_job_id               (job_id)
#  index_job_languages_on_job_id_and_language_id  (job_id,language_id) UNIQUE
#  index_job_languages_on_language_id             (language_id)
#  index_job_languages_on_language_id_and_job_id  (language_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_514cd69e1b  (language_id => languages.id)
#  fk_rails_94b0ff3621  (job_id => jobs.id)
#
