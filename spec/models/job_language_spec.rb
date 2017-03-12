# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobLanguage, type: :model do
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
#  fk_rails_291eb8392f  (language_id => languages.id)
#  fk_rails_adf9e1cd09  (job_id => jobs.id)
#
