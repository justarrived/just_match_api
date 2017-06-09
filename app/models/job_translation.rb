# frozen_string_literal: true

class JobTranslation < ApplicationRecord
  belongs_to :job

  include TranslationModel
end

# == Schema Information
#
# Table name: job_translations
#
#  id                       :integer          not null, primary key
#  locale                   :string
#  short_description        :string
#  name                     :string
#  description              :text
#  job_id                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  language_id              :integer
#  tasks_description        :text
#  applicant_description    :text
#  requirements_description :text
#
# Indexes
#
#  index_job_translations_on_job_id       (job_id)
#  index_job_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (language_id => languages.id)
#
